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
download_series_full <- function(forcedownload=FALSE) {

  .datos_server_path <- getOption("datos_server_path")
  .datos_path <- gsub("/",
                     "\\\\",
                     tools::R_user_dir("tesoroseries", which = "data"))
  
  if(check_db_lock() & !forcedownload) {
    stop("add_serie: database lock is set and forcedownload is set to FALSE.")
  }
  
  
  zip_file_server_path <- paste0(.datos_server_path, 
                                 "tesoroseries.zip")

  feathers_files_list_local <- fs::dir_ls(path=.datos_path,
                                    glob="*.feather")
  
  # deleting all existing feather files
  message("Deleting existing .feather files...")
  fs::file_delete(feathers_files_list_local)

  
  if(!file.exists(zip_file_server_path)) {
    stop("tesoroseries: download_series_full(): tesoroseries.zip does not exist in the server.")
  }

  # unzipping tesoroseries.zip in local data directory.
  tryCatch({
    
    unzip(zipfile=zip_file_server_path,
               exdir=paste0(.datos_path, "/"),
          junkpaths=TRUE)

    })
  
  set_last_update_local()
  
  message("Series successfully updated locally.")
  

}
