#' Print version of tesoroseries
#'
#' @keywords get tesoroseries version
#' @examples
#' version()
#' @export

version <- function() {
  
  message(getOption("tesoroseries_version"))
}
