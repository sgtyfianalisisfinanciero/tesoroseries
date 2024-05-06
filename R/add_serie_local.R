#' Add time series to the Tesoro series local repository
#'
#' This function locally adds a wide-format dataframe storing a serie, to the catalog of series and to the data repository of tesoroseries.
#' @param .df dataframe containing the serie to be added
#' @param .codigo code of the serie
#' @param .descripcion  description of the serie
#' @param .fichero path to .feather file containing the serie data
#' @keywords add serie
#' @examples
#' get_series()
#' s@export
add_serie_local <- function(.df,
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
  
  .datos_server_path <- getOption("datos_server_path")
  
  .datos_path <- gsub("\\\\",
                      "/",
                      tools::R_user_dir("tesoroseries", which = "data"))
  
  
  
  if(is.null(.df) | ncol(.df) > 2) {
    message("Dataframe cannot have more than two columns.")
    return(NULL)
  }
  
  existing_catalogo <- tryCatch({
    
    existing_catalogo_path <- paste0(.datos_path, "/catalogo_db.feather")

    feather::read_feather(existing_catalogo_path)
  },
  error = function(e) {
    message("Cannot read local copy of catalogo_db.feather")
    message("Path to file: ", .datos_server_path)
    message("Error: ", e)
    return(NULL)
  })

  if(nrow(existing_catalogo) > 0) { # check that catalogo_db.feather is not an empty one, otherwise it's necessarily a new serie to add
    existing_entry <- existing_catalogo |>
      dplyr::filter(nombre == paste0("TESORO_", 
                                     .codigo |> 
                                       stringr::str_remove("TESORO_")))
    # catalogo_db.feather already has some series, but not the one we are trying to add
    if (nrow(existing_entry) == 0) {
      message("New serie ", .codigo, ".")
      
      # catalogo_db.feather already contains a serie with the same name as the one to be added
    } else if(((existing_entry$nombre |> 
                unique()) == paste0("TESORO_", .codigo |> 
                                    stringr::str_remove("TESORO_"))) | 
              forceoverwrite == TRUE) {
      message("Código ", .codigo, " will be overwritten.")
      
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
    dplyr::mutate(
      codigo = paste0("TESORO_", .codigo),
      nombres = .descripcion,
      fichero = paste0(.datos_server_path, "/", .codigo, ".feather"),
      unidades=.unidades,
      decimales = .decimales,
      exponente = .exponente,
      descripcion_unidades_exponente = .descripcion_unidades_exponente,
      frecuencia = .frecuencia,
      decimales = .decimales,
      fuente = .fuente,
      notas = .notas
    ) |>
    filter(!is.na(valores))
  
  # guardar en LOCAL
  feather::write_feather(df_to_save,
                         paste0(.datos_path, "/", .codigo, ".feather"))
  
  # entrada de catálogo a añadir
  .entrada_catalogo <- dplyr::tibble(nombre =  paste0("TESORO_", .codigo),
                                     numero = "",
                                     alias=.descripcion,
                                     fichero = paste0(.datos_server_path, "/", .codigo, ".feather"),
                                     descripcion=.descripcion, 
                                     tipo="",
                                     unidades=.unidades,
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
    # eliminamos entrada del catálogo con mismo nombre para no añadir dos series repetidas cuando aumenta numero_observaciones
    filter(nombre != .entrada_catalogo$nombre) |>
    dplyr::bind_rows(.entrada_catalogo) |>
    dplyr::distinct()
  
  # save catalogo_db.feather in LOCAL
  message("Adding serie to local db...")
  feather::write_feather(x=catalogo,
                         path=paste0(.datos_path, "/catalogo_db.feather"))
  
  
  # save catalogo_db.feather in SERVER
  # message("Adding serie to the series in server...")
  # zip(zipfile=zip_file_server_path,
  #     files=paste0(.datos_path, "/catalogo_db.feather"),
  #     extras = '-j')
  
  set_last_update_local()
  
  return(.entrada_catalogo)
  
}