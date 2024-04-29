#' Checks whether local data has already been updated today. If not, download the full set of series from server.
#'
#' Usage:
#'    update_series(forcedownload = [TRUE|FALSE])
#'
#' @keywords download full banco de españa series
#' @export
#' @examples
#' download_series_full()

update_series <- function(forcedownload=FALSE) {

  .datos_path <- gsub("/",
                     "\\\\",
                     tools::R_user_dir("tesoroseries", which = "data"))
  
  
  .datos_server_path <- getOption("datos_server_path")
  

  
  if (!dir.exists(paste0(.datos_path))) { # }, "catalogo.feather"))){
    message("Creating tesoroseries data directory...")
    dir.create(.datos_path,
               recursive = TRUE)

  }
  
  last_updates_dates <- check_last_updates()
  
  # if there is no local last update date, do download_series_full()
  if(is.na(last_updates_dates["local_last_update"])) {
    message('last_updates_dates["local_last_update"]', last_updates_dates["local_last_update"])
    download_series_full()
  } else {
    # if server is more up to date than local
    if(forcedownload | (last_updates_dates["server_last_update"] > last_updates_dates["local_last_update"])) {
      if (last_updates_dates["server_last_update"] > last_updates_dates["local_last_update"]) {
        message("Server data is more up to date than local.")
        message("Server last update: ", last_updates_dates["server_last_update"])
        message("Local last update: ", last_updates_dates["local_last_update"])
        message("Updating local from server...")
      }
      
      if(forcedownload) {
        message("Forcing update...")
      }
      
      download_series_full()
      # if local is up to date or more up to date than local
    } else {
      message("Server last update: ", last_updates_dates["server_last_update"])
      message("Local last update: ", last_updates_dates["local_last_update"])
      if(last_updates_dates["server_last_update"] == last_updates_dates["local_last_update"]) {
        message("Local data is up to date")
      } else {
        message("Local data is more up to date than server data.")
      }
    }
  }
  

  

  

}


