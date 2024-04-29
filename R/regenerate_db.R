#' Regenerates the database containing the full catalog of series.
#'
#' This function scans the local storage of series and generates a local copy of catalogo_db.feather containing all
#' the columns that catalogo_db.feather is expected to have. 
#' By default
#' #' @param update_to_server whether the catalogo_db.feather file will be updloaded to tesoroseries.zip in server
#' @keywords regenerate generate database db catalogo_db.feather
#' @examples
#' regenerate_db()
#' s@export
regenerate_db <- function(update_to_server=FALSE) {
  
  .datos_server_path <- getOption("datos_server_path")
  .datos_path <- gsub("/",
                      "\\\\",
                      tools::R_user_dir("tesoroseries", which = "data"))
  
  catalogo_db_path <- paste0(
    .datos_path,
    "\\",
    "catalogo_db.feather"
  )
  
  zip_file_server_path <- iconv(paste0(.datos_server_path, "tesoroseries.zip"),
                                "UTF-8", 
                                "UTF-8")
  
  tmpg_catalogo_db_path <- tempfile()
  
  generate_catalog_row <- function(.serie_file) {
    
    # .serie_file <- "C:/Users/mfabian/AppData/Roaming/R/data/R/tesoroseries/CBP2012_DETALLEDENEGADAS_NUMERODEOPERACIONESCONPRECIOVIVIENDAFUERADERANGOSART5.2_BBVA.feather"
    
    .serie_df <- feather::read_feather(
      .serie_file
    )
    .serie_df_row <- .serie_df[1,] 
    
    .entrada_catalogo <- dplyr::tibble(
      nombre =  .serie_df_row$codigo,
      numero = "" ,
      alias=.serie_df_row$nombres,
      # fichero = NA, 
      fichero = .serie_file |> as.character() |> stringr::str_split("/") |> _[[1]] |> _[-c(1:3)] |> paste(collapse="/"),
      descripcion=.serie_df_row$nombres, 
      tipo="",
      unidades=.serie_df_row$unidades|> as.character(),
      decimales = .serie_df_row$decimales|> as.character(),
      exponente = .serie_df_row$exponente|> as.character(),
      numero_observaciones=nrow(.serie_df) |> as.integer(),
      descripcion_unidades_exponente = .serie_df_row$descripcion_unidades_exponente,
      # fecha_primera_observacion= NA,
      fecha_primera_observacion=as.Date(min(.serie_df$fecha)),
      fecha_ultima_observacion=as.Date(max(.serie_df$fecha)),
      # fecha_ultima_observacion= NA,
      titulo="",
      frecuencia = .serie_df_row$frecuencia |> as.character(),
      fuente = .serie_df_row$fuente|> as.character(),
      notas = .serie_df_row$notas|> as.character())
    
    return(.entrada_catalogo)
    
  }

  
  message("Regenerating db... It may take long.")
  
  cl <- snow::makeCluster(parallel::detectCores() - 1)
  
  catalogo_regenerado_db <- snow::parLapply(
    cl=cl,
    fs::dir_ls(
      .datos_path,
      glob="*.feather"
    ),
    generate_catalog_row
    # simplify=TRUE,
    # USE.NAMES = FALSE
  )
  snow::stopCluster(cl)
  
  catalogo_regenerado_db <- setNames(catalogo_regenerado_db,
           NA) |> 
    dplyr::bind_rows() |>
    distinct() |>
    filter(!is.na(nombre))
  
  message("Saving catalogo_db.feather to local directory...")
  feather::write_feather(
    catalogo_regenerado_db,
    catalogo_db_path
  )
  
  message("Series successfully regenerated and updated locally.")
  
  if(update_to_server) {
    message("Updating catalogo_db.feather to server...")
    # zipping local data directory to tesoroseries.zip in server
    tryCatch({
      
      zip(zipfile=zip_file_server_path,
          files=paste0(.datos_path, "/catalogo_db.feather"),
          extras = '-j')
    },
    error = function(e) {
      stop("update_local_to_server: ", e)
    })
    
  }
  
  
}