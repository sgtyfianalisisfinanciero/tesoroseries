#' Dump the full Tesoro series catalog.
#'
#' This function returns the full catalog of Tesoro series.
#'
#' @keywords dump full banco de españa series catalog
#' @export
#' @examples
#' get_catalog()

get_catalog <- function(forcedownload=FALSE) {
  
  .datos_path <- gsub("\\\\",
                     "/",
                     tools::R_user_dir("tesoroseries", which = "data"))
  
  if(check_db_lock() & !forcedownload) {
    stop("add_serie: database lock is set and forcedownload is set to FALSE.")
  }

  return(feather::read_feather(path=paste0(.datos_path, "/catalogo_db.feather")))

}
