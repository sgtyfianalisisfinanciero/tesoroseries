.onLoad <- function(...) {
  .datos_server_path <- paste0(gsub("\\\\", 
                                   "/", Sys.getenv("USERPROFILE")), "/OneDrive - MINECO/General - SG Análisis Financiero-Teams/tesoroseries/")
  
  options("datos_server_path"=.datos_server_path)
  options("tesoroseries_version"="v0.23-20240429")
  options("lockfilename"=".tesoroseries_lock")
  
  packageStartupMessage(paste0("tesoroseries ", getOption("tesoroseries_version"), "- miguel@fabiansalazar.es"))
  



  .datos_path <- gsub("/",
                     "\\\\",
                     tools::R_user_dir("tesoroseries", which = "data"))
  
  # tesoroseries/ -> inicializar en local
  if (!dir.exists(paste0(.datos_path))) { # }, 
    message("Creating tesoroseries data directory...")
    dir.create(.datos_path,
               recursive = TRUE)
    
  }
  
  
  # tesoroseries/ -> inicializar en servidor
  if (!dir.exists(paste0(.datos_server_path))) { # }, 
    message("Creating tesoroseries data directory...")
    dir.create(.datos_path,
               recursive = TRUE)
    
  }
  
  # if there is no tesoroseries.zip in server, we initialize an empty one.
  if(!file.exists(paste0(.datos_server_path, "tesoroseries.zip"))) {
    message("tesoroseries.zip does not exist. Creating...")
    tempdir_tesoroseries_zip_path <- gsub("\\\\","/",
                                          
                                          paste0(tempdir(), "\\catalogo_db.feather"))
    catalogo_db <- dplyr::tibble()
    
    feather::write_feather(catalogo_db, "catalogo_db.feather")
    zip::zip(zipfile = paste0(.datos_server_path, "tesoroseries.zip"),
             files="catalogo_db.feather")
  }
  
  update_series()
  
  
}
