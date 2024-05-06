#' Retrieve time series from the Tesoro series repository
#'
#' This function returns a tibble containing the series that match the given series' code(s)
#' @param codes series' code(s) to be downloaded
#' @keywords download get series
#' @examples
#' get_series()
#' s@export


get_series <- function(codes,
                       verbose=FALSE,
                       usefulldatabase=FALSE,
                       .forcedownload=FALSE) {
  
  if(length(codes) == 0) {
    message("No codes to be retrieved.")
    return(NULL)
  }
  
  datos_path <- gsub("\\\\", "/",
                      tools::R_user_dir("tesoroseries", which = "data"))
  


  .series_final_df <- dplyr::tibble()


  for (.code in codes) {
    
    tryCatch({
      .series_final_df <- dplyr::bind_rows(
        .series_final_df,
        feather::read_feather(
          paste0(datos_path, "/", stringr::str_remove(.code, "TESORO_"), ".feather")
          )
        )
    },
    error=function(e) {
      
    })
    


  }

  .series_final_df <- .series_final_df |>
    dplyr::arrange(fecha)

  return(.series_final_df)
}
