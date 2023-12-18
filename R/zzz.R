.onLoad <- function(...) {
  packageStartupMessage("tesoroseries v0.1-20231218 - miguel@fabiansalazar.es")

  options("datos_server_path"="\\\\SERVERDATOS01/vol3/ANALISIS-FINANCIERO/tesoroseries/datos/")

  
  datos_server_path <- getOption("datos_server_path")
  
  
  datos_path <- gsub("/",
                     "\\\\",
                     tools::R_user_dir("tesoroseries", which = "data"))
  
  if (!dir.exists(paste0(datos_path))) { # }, "catalogo.feather"))){
    message("Creating tesoroseries data directory...")
    dir.create(datos_path,
               recursive = TRUE)
    
  }
  
  if (!dir.exists(paste0(datos_server_path))) { # }, "catalogo.feather"))){
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
