

#' Get color for cases per 100K similar to Mass DPH color scheme
#'
#' @param numeric cases
#'
#' @return string with case category color
#' @export

get_cases_category <- function(cases) {
  the_category <- dplyr::case_when(
    cases == 0 | is.na(cases) ~ "White",
    cases > 0 & cases < 4 ~ "Green",
    cases >= 4 & cases <= 8 ~ "Yellow",
    cases > 8 ~ "Red"
  )
  return(the_category)
}



#' Convert vector of characters to integer or number if needed
#'
#' @param item string that needs to be converted
#' @param thetype string "number" or "integer"
#'
#' @return
#' @export
#'

fix_characters <- function(item, thetype = "number") {
  if(thetype == "number") {
    if(is.character(item)) {
      item <- readr::parse_number(item)
    }
  } else if (thetype == "integer") {
    if(is.character(item)) {
      item <- readr::parse_integer(item)
    }
  }
  return(item)
}


#' Get category color for test positivity rate based on my own scheme
#'
#' @param positivity numeric
#'
#' @return string with case category color
#' @export
get_positivity_category <- function(positivity) {
  the_category <- dplyr::case_when(
    positivity <= 1 ~ "1.0 or Below",
    positivity > 1 & positivity <= 2 ~ "Very Low",
    positivity > 2 & positivity <= 3 ~ "Low",
    positivity > 3 & positivity <= 4 ~ "Moderate",
    positivity > 4 & positivity <= 5 ~ "Concern",
    positivity > 5 & positivity <= 10  ~ "High",
    positivity > 10  ~ "Very High"
  )

  return(the_category)
}



