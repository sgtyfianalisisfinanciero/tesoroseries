#' Download the full set of Tesoro series database
#'
#' This function downloads and stores the full catalog of Tesoro data series.
#'
#' @keywords download full banco de españa series
#' @export
#' @examples
#' download_series_full()

download_series_full <- function(forcedownload=FALSE) {

  datos_path <- gsub("/",
                     "\\\\",
                     tools::R_user_dir("tesoroseries", which = "data"))
  
  
  datos_server_path <- getOption("datos_server_path")
  

  if (!dir.exists(paste0(datos_path))) { # }, "catalogo.feather"))){
    message("Creating tesoroseries data directory...")
    dir.create(datos_path,
               recursive = TRUE)

  }

  if(length(list.files(datos_path, pattern="csv")) == 0) {
    update_series()
    return()
  }
  # 1. listamos los .feather en datos_path,
  # 2. escogemos alguno de los feather en datos_path, al azar
  # 3. extraemos fecha de última modificación
  # 4. comprobamos no es null
  # 5. comprobamos esta fecha es igual a la de hoy, y no se ha pedido actualización forzosa
  if (!is.na(as.Date((file.info(paste0(datos_path, "\\", list.files(datos_path, pattern="csv") |> sample(1))))$mtime))) {
    message("Date of last update: ", as.Date((file.info(paste0(datos_path, "\\", list.files(datos_path, pattern="csv") |> sample(1))))$mtime) )
    if (as.Date((file.info(paste0(datos_path, "\\", list.files(datos_path, pattern="csv") |> sample(1))))$mtime) == Sys.Date() & !forcedownload) {
      message("Tesoro data have already been downloaded today.")
      return()
    } else {
      update_series()
    }
  }




}

