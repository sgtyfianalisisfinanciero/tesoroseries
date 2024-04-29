#' Set the lock on the server database storage.
#'

#' 
#' This check should be called at the beginning of any exportable function which updates or downloads tesoroseries.zip from SERVER.
#' #' @param update_to_server whether the catalogo_db.feather file will be updloaded to tesoroseries.zip in server
#' @keywords regenerate generate database db catalogo_db.feather
#' @examples
#' set_db_lock()
#' 

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


#' Check whether the lock is set.
#' This function checks for the existence of a lock file in server directory (".tesoroseries_lock"). If it does exists, execution is aborted. 
#'
#' By default
#' @keywords check lock database db catalogo_db.feather
#' @examples
#' check_db_lock()

check_db_lock <- function() {
  .datos_server_path <- getOption("datos_server_path")
  lockfilename <- paste0(.datos_server_path,
                         getOption("lockfilename"))
  
  return(fs::file_exists(lockfilename) |> _[[1]])

}

#' Remove lock in server.
#'
#' This function deletes an existing lock in the form of a ".tesoroseries_lock" file in server directory.
#' @keywords remove lock database db catalogo_db.feather
#' @examples
#' remove_db_lock()
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