#' Update the series.
#'
#' This function downloads the datasets from tesoro, replacing the existing feather files containing the series (if any).
#'
#' @keywords update download tesoro series
#' @export
#' @examples
#' update_series()
#'
#'
#'
update_series <- function() {

  datos_server_path <- getOption("datos_server_path")
  
  datos_path <- gsub("/",
                     "\\\\",
                     tools::R_user_dir("tesoroseries", which = "data"))



  feathers_files_list <- fs::dir_ls(path=datos_server_path,
                               glob = "*.feather")
  
  if(is.null(feathers_files_list)) {
    stop("tesoroseries: update_series(): no files to copy")
  }

  tryCatch({file.copy(paste0(datos_server_path, feathers_files_list), datos_path, overwrite=TRUE)},
           error=function(e) {
             message("Cannot copy feather files to path ", datos_path)
             mesage("Error: ", e)
             stop("tesoroseries: update_series(): cannot copy feather files to path ", datos_path, ": ", e)
           })
  
  return()

}
