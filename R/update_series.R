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
  
  if (!forcedownload) { # if we are not forcing update
    if (!is.na(as.Date((file.info(paste0(.datos_path, "\\", 
                                         list.files(.datos_path, pattern="feather") |> 
                                         sample(1))))$mtime))) { # if mtimes of feather files are not NA
      message("Date of last update: ", as.Date((file.info(paste0(.datos_path, "\\", 
                                                                 list.files(.datos_path, 
                                                                            pattern="feather") |> sample(1))))$mtime)) # print date of latest update
      
      if (as.Date((file.info(paste0(.datos_path, "\\", 
                                    list.files(.datos_path, pattern="feather") |> 
                                    sample(1))))$mtime) == Sys.Date()) { # check whether latest update's date equals today's
        message("tesoroseries data have already been downloaded today.")
        return()
      } else {
        download_series_full()
      }
    }
  
  
    if(length(list.files(.datos_path, pattern="csv")) == 0) {
      download_series_full()
      return()
    }
  } else { # forced update
    download_series_full()
  }
  

}

