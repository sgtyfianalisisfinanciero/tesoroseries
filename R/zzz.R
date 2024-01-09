.onLoad <- function(...) {
  packageStartupMessage("tesoroseries v0.13-20240109 - miguel@fabiansalazar.es")
  
  datos_server_path <- paste0(gsub("\\\\", 
                                   "/", Sys.getenv("USERPROFILE")), "/OneDrive - MINECO/General - SG Análisis Financiero-Teams/tesoroseries/")

  # options("datos_server_path"="\\\\SERVERDATOS01/vol3/ANALISIS-FINANCIERO/tesoroseries/datos/")
  options("datos_server_path"=datos_server_path)

  
  # datos_server_path <- gsub("\\\\", 
  #                           "/",
  #                           getOption("datos_server_path"))

  datos_path <- gsub("/",
                     "\\\\",
                     tools::R_user_dir("tesoroseries", which = "data"))
  
  # tesoroseries/ -> inicializar en local
  if (!dir.exists(paste0(datos_path))) { # }, 
    message("Creating tesoroseries data directory...")
    dir.create(datos_path,
               recursive = TRUE)
    
  }
  
  
  # tesoroseries/ -> inicializar en servidor
  if (!dir.exists(paste0(datos_server_path))) { # }, 
    message("Creating tesoroseries data directory...")
    dir.create(datos_path,
               recursive = TRUE)
    
  }
  
  if(!file.exists(paste0(datos_server_path, "catalogo_db.feather"))) {
    feather::write_feather(dplyr::tibble(),
                           paste0(datos_server_path, "catalogo_db.feather"))
  }
  
  download_series_full()
  
}
