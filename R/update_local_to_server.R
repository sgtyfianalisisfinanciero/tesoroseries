#' Updates the server database from the local one.
#'
#' This function copies the local database to the server. It should be used in conjunction with add_serie_local when 
#' adding series in bulk, instead of making multiple calls to add_serie()
#' @keywords update local to server
#' @examples
#' update_local_to_server()
#' s@export
update_local_to_server <- function(force_update_to_server=FALSE) {
  
  .datos_server_path <- getOption("datos_server_path")
  .datos_path <- gsub("/",
                      "\\\\",
                      tools::R_user_dir("tesoroseries", which = "data"))
  
  if(check_db_lock() & !force_update_to_server) {
    stop("add_serie: database lock is set and forcedownload is set to FALSE.")
  }
  
  set_db_lock()
  
  zip_file_server_path <- iconv(paste0(.datos_server_path, "/", "tesoroseries.zip"),
                                "UTF-8", 
                                "UTF-8")
  
  tryCatch({
    feathers_files_list_local <- gsub("/",
                                      "\\\\",
                                      fs::dir_ls(
                                        path=.datos_path,
                                        glob="*.feather"
                                      )
    ) |> 
      unlist()
  },
  error=function(e) {
    remove_db_lock()
    stop("update_local_to_server: cannot read .feather files from local directory: ",e)
  })
  
  
  if(!file.exists(zip_file_server_path)) {
    message("tesoroseries: download_series_full(): tesoroseries.zip does not exist in the server.")
  }
  
  # zipping local data directory to tesoroseries.zip in server
  tryCatch({
    temp_feathers_files_zipfile <- gsub("/",
                                        "\\\\",
                                        tempfile(
                                          # tmpdir=paste0(Sys.getenv("USERPROFILE"),"\\AppData\\Local\\Temp\\2"),
                                          fileext=".zip"
                                        ),
    ) 
    
    feathers_files_list_local <- c(
      feathers_files_list_local, 
      paste0(.datos_path, "/catalogo_db.feather")
    ) 
    
    # message("Tmpfile: ", temp_feathers_files_zipfile)
    message("Zipping LOCAL files together...")
    
    # utils::zip(
    #   zipfile=temp_feathers_files_zipfile,
    #   files=feathers_files_list_local,
    #   # extras = '-j'
    # )
    
    zip::zip(
      zipfile=temp_feathers_files_zipfile,
      files=feathers_files_list_local,
      root = ".",
      include_directories=FALSE,
      mode = "cherry-pick"
    )
    
    fs::file_copy(
      paste0(temp_feathers_files_zipfile),
      zip_file_server_path,
      overwrite=TRUE
    )
  },
  error = function(e) {
    remove_db_lock()
    stop("update_local_to_server: ", e)
  })
  
  set_last_update_server(equal_to_local=TRUE)
  remove_db_lock()
  
  message("Series successfully updated from local to server.")
  
  
}