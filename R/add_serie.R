#' Add time series to the Tesoro series repository
#'
#' This function adds a wide-format df storing a serie to the catalog of series and to the data repository of tesoroseries.
#' @param .df dataframe containing the serie to be added
#' @param .codigo code of the serie
#' @param .descripcion  description of the serie
#' @param .fichero path to .feather file containing the serie data
#' @keywords add serie
#' @examples
#' get_series()
#' s@export


add_serie <- function(.df,
                      .codigo,
                      .descripcion,
                      .fichero="",
                      .unidades="",
                      .exponente="",
                      .descripcion_unidades_exponente="",
                      .frecuencia="",
                      .decimales="",
                      .fuente="",
                      .notas="",
                      .db="",
                       verbose=FALSE,
                      forceoverwrite = FALSE) {
  
  
  
  # .codigo="AVALES_ICOCOVID_CIR_FINDISPONIBLETOTAL"
  # .descripcion="Avales ICO Covid-19. CIR. Financiación disponible total"
  # .fichero=paste0(datos_path, "AVALES_ICOCOVID_CIR_FINDISPONIBLETOTAL", ".feather")
  # .unidades="euros"
  # .exponente="1"
  # .descripcion_unidades_exponente=""
  # .frecuencia="MENSUAL"
  # .decimales="0"
  # .fuente="CIR"
  # .notas=""
  # .db=""
  # verbose=FALSE
  # forceoverwrite = FALSE
  
  datos_server_path <- getOption("datos_server_path")
  
  datos_path <- gsub("\\\\",
                     "/",
                     tools::R_user_dir("tesoroseries", which = "data"))
  
  if(is.null(.df) | ncol(.df) > 2) {
    message("Dataframe cannot have more than two columns.")
    return(NULL)
  }
  
  tryCatch({existing_catalogo_path <- gsub("/",
                                           "\\\\",
                                           paste0(datos_server_path, "catalogo_db.feather"))
  
            existing_catalogo <- feather::read_feather(existing_catalogo_path)},
           error = function(e) {
             message("Cannot read catalogo_db.feather")
             message("Path to file: ", datos_server_path)
             message("Error: ", e)
             return(NULL)
             })
  
  if(nrow(existing_catalogo) > 0) {
    existing_entry <- existing_catalogo |>
      dplyr::filter(nombre == .codigo)

    if (nrow(existing_entry) == 0) {
      message("New serie ", .codigo, ".")
    } else if((existing_entry$nombre |> unique()) == .codigo) {
      message("Código ", .codigo, " will be overwritten, since both .nombre matches the already existing fields.")
    # } else if (((existing_entry$nombre |> unique()) != .codigo) & ((existing_entry$nombre |> unique()) != .descripcion)) {
    #   message("New serie ", .codigo, ".")
    } else {
      message("Serie will not be stored.")
      message("Both fields 'nombre' and 'descripcion' need to match existing series' catalog entry.")
      return(NULL)
    }
    
  } else {
    message("New serie ", .codigo, ".")
  }
  


  message("Storing serie ", .codigo, ".")
  
  # df con los datos a guardar
  df_to_save <- .df |>
    tidyr::pivot_longer(cols=-c("fecha"),
                 names_to="nombres",
                 values_to="valores") |>
    dplyr::mutate(codigo = paste0("TESORO_", .codigo),
                  nombres = .descripcion,
                  fichero = paste0(datos_server_path, .codigo, ".feather"),
                  decimales = .decimales,
                  exponente = .exponente,
                  descripcion_unidades_exponente = .descripcion_unidades_exponente,
                  frecuencia = .frecuencia,
                  decimales = .decimales,
                  fuente = .fuente,
                  notas = .notas)
  
  # guardar en LOCAL
  feather::write_feather(df_to_save,
                         paste0(datos_path, .codigo, ".feather"))
  
  # guardar en SERVIDOR
  feather::write_feather(df_to_save,
                         paste0(datos_server_path, .codigo, ".feather"))
  
  # entrada de catálogo a añadir
  .entrada_catalogo <- dplyr::tibble(nombre =  paste0("TESORO_", .codigo),
                              numero = "",
                              alias=.descripcion,
                              fichero = paste0(datos_server_path, .codigo, ".feather"),
                              descripcion=.descripcion, 
                              tipo="",
                              unidades="",
                              decimales = .decimales,
                              exponente = .exponente,
                              numero_observaciones=nrow(.df),
                              descripcion_unidades_exponente = .descripcion_unidades_exponente,
                              fecha_primera_observacion=min(.df$fecha),
                              fecha_ultima_observacion=max(.df$fecha),
                              titulo="",
                              frecuencia = .frecuencia,
                              fuente = .fuente,
                              notas = .notas)
  
  catalogo <- existing_catalogo |>
    dplyr::bind_rows(.entrada_catalogo) |>
    dplyr::distinct()
  
  message("Adding serie to the series in server...")
  feather::write_feather(x=catalogo,
                         path=paste0(datos_server_path, "catalogo_db.feather"))
  
  message("Adding serie to local db...")
  feather::write_feather(x=catalogo,
                         path=paste0(datos_path, "/catalogo_db.feather"))
  
  return(.entrada_catalogo)
  
}