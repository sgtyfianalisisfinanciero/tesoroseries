#' Updates the server database from the local one.
#'
#' This function copies the local database to the server. It should be used in conjunction with add_serie_local when 
#' adding series in bulk, instead of making multiple calls to add_serie()
#' @keywords update local to server
#' @examples
#' update_local_to_server()
#' s@export
update_local_to_server <- function() {
  
  .datos_server_path <- getOption("datos_server_path")
  .datos_path <- gsub("/",
                      "\\\\",
                      tools::R_user_dir("tesoroseries", which = "data"))
  
  
  # zip_file_server_path <- paste0(.datos_server_path, 
  #                                "tesoroseries.zip")
  
  zip_file_server_path <- iconv(paste0(.datos_server_path, "tesoroseries.zip"),"UTF-8", "UTF-8")
  
  feathers_files_list_local <- fs::dir_ls(path=.datos_path,
                                          glob="*.feather")
  

  if(!file.exists(zip_file_server_path)) {
    stop("tesoroseries: download_series_full(): tesoroseries.zip does not exist in the server.")
  }
  
  # zipping local data directory to tesoroseries.zip in server
  tryCatch({
    
    zip(zipfile=zip_file_server_path,
        files=feathers_files_list_local,
        extras = '-j')
    
    zip(zipfile=zip_file_server_path,
        files=paste0(.datos_path, "/catalogo_db.feather"), 
        extras = '-j')
    
  },
  error = function(e) {
    stop("update_local_to_server: ", e)
  })
  
  message("Series successfully updated locally.")
  
  
}