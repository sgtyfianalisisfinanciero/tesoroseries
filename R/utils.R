#' Check dates of last updates in server and local.
#'
#' This function returns a named list containing the date of last update in server ($server_last_update) and the date of last update in local ($local_last_update)
#' @keywords remove lock database db catalogo_db.feather
#' @examples
#' check_last_updates()
#' @export
check_last_updates <- function() {
  .datos_server_path <- getOption("datos_server_path")
  .datos_path <- gsub("\\\\",
                      "/",
                      tools::R_user_dir("tesoroseries", which = "data"))
  .local_last_update_file <- paste0(
    .datos_path,
    "/",
    getOption("local_last_update_file")
  )
  
  .server_last_update_file <- paste0(
    .datos_server_path,
    "/",
    getOption("server_last_update_file")
  )

  
  if(!fs::file_exists(.local_last_update_file) & 
     !fs::file_exists(.server_last_update_file)) {
    message("Local last update file_exists output: ", fs::file_exists(.local_last_update_file))
    message("Server last update file exists: ", fs::file_exists(.server_last_update_file))
    stop("Aborting...")
  }
  
  
  # retrieve dates of last update from server and local
  # if local date of last update does not exists, a new one will be created.
  tryCatch(
    {
      server_last_update <- feather::read_feather(
        .server_last_update_file
      ) |>
        _$last_update_date
      
      message("server_last_update: ", server_last_update)
      
      local_last_update <- feather::read_feather(
        .local_last_update_file
      ) |>
        _$last_update_date
      
      message("local_last_update: ", local_last_update)
    },
    error = function(e) {
      stop("check_last_updates: Error reading/writing dates of last update: ", e)
    }
  )
  
  
  return(c(
    server_last_update=server_last_update,
    local_last_update=local_last_update
    ))
}

#' set date of last update in local to now.
#' 
#' This function sets the date of last update in the local directory, writing a feather file that contains a tibble with a single column named last_update_date.
#'
#' @keywords set date last update local
#' @examples
#' set_last_update_local()
#' @export
set_last_update_local <- function(equal_to_server=FALSE) {
  .datos_path <- gsub("\\\\",
                      "/",
                      tools::R_user_dir("tesoroseries", which = "data"))
  .local_last_update_file <- paste0(
    .datos_path,
    "/",
    getOption("local_last_update_file")
  )
  
  if(equal_to_server) {
    # local date of last update must be equal to the server's last update date.
    # We check the current date in server, then assign it to date_to_update
    date_to_update <- check_last_updates()["server_last_update"][[1]]
  } else {
    date_to_update = lubridate::now()
  }

  tryCatch({
    feather::write_feather(
      dplyr::tibble(last_update_date=date_to_update),
      .local_last_update_file
    )
  },
  error = function(e) {
    message("set_last_update_local: could not save date to file ", .local_last_update_file)
  })
  
}

#' set date of last update in server to now.
#' 
#' This function sets the date of last update in the server directory, writing a feather file that contains a tibble with a single column named last_update_date.
#'
#' @keywords set date last update local
#' @examples
#' set_last_update_server()
#' @export
set_last_update_server <- function(equal_to_local=FALSE) {
  .datos_server_path <- getOption("datos_server_path")
  
  .server_last_update_file <- paste0(
    .datos_server_path,
    "/",
    getOption("server_last_update_file")
  )
  
  if(equal_to_local) {
    # local date of last update must be equal to the server's last update date.
    # We check the current date in server, then assign it to date_to_update
    date_to_update <- check_last_updates()["local_last_update"][[1]]
  } else {
    date_to_update = lubridate::now()
  }
  
  tryCatch({
    feather::write_feather(
      dplyr::tibble(last_update_date=date_to_update),
      .server_last_update_file
    )
  },
  error = function(e) {
    message("set_last_update_server: could not save date to file ", .server_last_update_file)
  })
  
}

#' Check whether lock is set in the server.
#' 
#' This function checks for the existence of a lock file in server directory (".tesoroseries_lock"). If it does exists, execution is aborted. 
#'
#' @keywords check lock database db catalogo_db.feather
#' @examples
#' check_db_lock()
#' @export
check_db_lock <- function() {
  .datos_server_path <- getOption("datos_server_path")
  lockfilename <- paste0(.datos_server_path,
                         getOption("lockfilename"))
  
  return(fs::file_exists(lockfilename) |> _[[1]])
  
}

#' Set the lock on the server database storage.
#'
#' This check should be called at the beginning of any exportable function which updates or downloads tesoroseries.zip from SERVER.
#' #' @param update_to_server whether the catalogo_db.feather file will be updloaded to tesoroseries.zip in server
#' @keywords regenerate generate database db catalogo_db.feather
#' @examples
#' set_db_lock()
#' @export
set_db_lock <- function() {
  .datos_server_path <- getOption("datos_server_path")
  lockfilename <- paste0(.datos_server_path,
                         getOption("lockfilename"))
  
  tryCatch({
    fs::file_touch(lockfilename)
  },
  error = function(e) {
    message("set_db_lock: could not set lock: ", e)
  })
  
}

#' Remove the lock on the server database storage.
#'
#' Removes the file signalling a lock in the database in the server.
#' This function should be called at the end of any exportable function which updates or downloads tesoroseries.zip from SERVER.
#' @keywords remove database lock catalogo_db.feather
#' @examples
#' remove_db_lock()
#' @export
remove_db_lock <- function() {
  .datos_server_path <- getOption("datos_server_path")
  lockfilename <- paste0(.datos_server_path,
                         getOption("lockfilename"))
  
  tryCatch({
    fs::file_delete(lockfilename)
  },
  error = function(e) {
    message("set_db_lock: could not remove lock: ", e)
  })
}




