#' Print version of tesoroseries
#'
#' @keywords get tesoroseries version
#' @examples
#' version()
#' s@export

version <- function() {
  
  message(getOption("tesoroseries_version"))
}
