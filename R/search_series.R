#' Search for series in the Tesoro series database.
#'
#' This function takes a list of search strings and returns a list of dataframes containing the results for each search string.
#'
#' The list of search strings are all matched AND-wise at the list element level, and OR-wise at the word level within a list element. Example:
#' search_str <- c("Ucrania", "ICO") would be matched against the chosen field as follows: ("Ucrania") AND ("ICO")
#'
#' By default, search_series() matches each field "descripcion" of the Tesoro series catalog. However, the field to be matched
#' can be modified by passing the name of the variable to be matched against to argument 'field', i.e.: search_series(search_str=c("Ucrania", "ICO"), field="unidades")
#' @param search_str search string(s) to be matched.
#' @keywords search series
#' @export
#' @examples
#' search_series()

search_series <- function(search_str,
                          field="descripcion") {


  results <- dplyr::tibble(tesoroseries::get_catalog())

  for (search_item in search_str) {
    results <- results |> dplyr::filter(grepl(stringr::str_replace(search_item,
                                                                   " ",
                                                                   "|"),
                                              eval(as.symbol(field)),
                                              ignore.case=TRUE))
  }



  return(results)

}
