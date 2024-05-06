.onLoad <- function(...) {
  .datos_path <- gsub("/",
                      "\\\\",
                      tools::R_user_dir("tesoroseries", which = "data"))
  .datos_server_path <- paste0(gsub("\\\\", 
                                   "/", Sys.getenv("USERPROFILE")), "/OneDrive - MINECO/General - SG Análisis Financiero-Teams/tesoroseries")
  
  options("datos_server_path"=.datos_server_path)
  options("tesoroseries_version"="v0.30-20240429")
  options("lockfilename"=".tesoroseries_lock")
  options("local_last_update_file"=".local_last_update")
  options("server_last_update_file"=".server_last_update")
  
  .local_last_update_file <- getOption("local_last_update_file")
  .server_last_update_file <- getOption("server_last_update_file")
  
  packageStartupMessage(paste0("tesoroseries ", getOption("tesoroseries_version"), "- miguel@fabiansalazar.es"))

  
  # tesoroseries/ -> inicializar en local
  if (!dir.exists(paste0(.datos_path))) { # }, 
    message("Creating tesoroseries data directory...")
    dir.create(.datos_path,
               recursive = TRUE)
    
  }
  
  # if there is no tesoroseries.zip in server, we initialize an empty one.
  if(!file.exists(paste0(.datos_path, "/", "catalogo_db.feather"))) {
    message("catalog_db.feather does not exist in local .datos_path. Creating...")
    # tempdir_tesoroseries_zip_path <- gsub("\\\\","/",
    #                                       paste0(tempdir(), "\\catalogo_db.feather"))
    
    feather::write_feather(dplyr::tibble(),
                           paste0(
                             .datos_path,
                             "/",
                             "catalogo_db.feather"
                             )
                           )
    
    # zip::zip(zipfile = paste0(.datos_server_path, "/", "tesoroseries.zip"),
    #          files=tempdir_tesoroseries_zip_path)
  }
  
  # tesoroseries/ -> inicializar en servidor
  if (!dir.exists(paste0(.datos_server_path))) { # }, 
    message("Creating tesoroseries data directory...")
    dir.create(.datos_path,
               recursive = TRUE)
    
  }
  
  # if there is no tesoroseries.zip in server, we initialize an empty one.
  if(!file.exists(paste0(.datos_server_path, "/", "tesoroseries.zip"))) {
    message("tesoroseries.zip does not exist. Creating...")
    tempdir_tesoroseries_zip_path <- gsub("\\\\","/",
                                          paste0(tempdir(), "\\catalogo_db.feather"))

    feather::write_feather(dplyr::tibble(),
                           tempdir_tesoroseries_zip_path)
    
    zip::zip(zipfile = paste0(.datos_server_path, "/", "tesoroseries.zip"),
             files=tempdir_tesoroseries_zip_path)
  }
  
  
  
  # if dates of last update do not exist in server and/or local, create
  # local
  if(!fs::file_exists(
    paste0(
      .datos_path,
      "/",
      .local_last_update_file
      ))) {
    message("Local date of last update could not be retrieved.")
    message("Writing new date of last update in local")
    set_last_update_local()
      }
  # server
  if(!fs::file_exists(
    paste0(
      .datos_server_path,
      "/",
      .server_last_update_file
      ))) {
    message("server date of last update could not be retrieved.")
    message("Writing new date of last update in local")
    set_last_update_server()
    
  }
  
  # check_last_updates()
  
  
  update_series()
  
  
}
