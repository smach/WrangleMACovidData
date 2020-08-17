


#' Generate HTML table of data by community
#'
#' @param the_spreadsheet Mass DPH spreadsheet of weekly public health data
#'
#' @return
#' @export
#'
#' @examples
#' #'\dontrun{
#' new_table <- generate_html_table_by_place("Weekly_Dashboard_Data.xlsx")
#' }
generate_html_table_by_place <- function(the_spreadsheet) {
  options(scipen = 999)
  by_place <- readxl::read_xlsx(the_spreadsheet, sheet = "City_Town_Data")

  names(by_place) <- c("Place", "Cases", "CasesLast14Days", "AvgDailyPer100K", "RelativeChange", "TotalTested", "TotalTestedLast14Days", "TotalPositiveLast14Days", "PctPositive", "ChangePctPositivity")

  by_place <- by_place %>%
    dplyr::mutate(
      Cases = as.vector(Cases),
      Cases = suppressWarnings(readr::parse_integer(Cases)),
      CasesLast14Days = suppressWarnings(as.numeric(CasesLast14Days)),
      AvgDailyPer100K = round(suppressWarnings(readr::parse_number(AvgDailyPer100K)), 1),
      AvgDailyPer100K = as.vector(AvgDailyPer100K),
      PctPositive = suppressWarnings(readr::parse_number(PctPositive)),
      PctPositive = as.vector(PctPositive)
    ) %>%
    dplyr::filter(!is.na(Cases)) %>%
    dplyr::arrange(desc(PctPositive))

  by_place$PositiveRank = seq(1:nrow(by_place))

  the_table <- DT::datatable(by_place, options = list(pageLength = 350), rownames = FALSE, filter = 'top') %>%
    DT::formatCurrency(c(2,3,6,7,8), "", digits = 0 ) %>%
    DT::formatPercentage(9, digits = 1) %>%
    DT::formatStyle(
      c('ChangePctPositivity', 'RelativeChange'),
      backgroundColor = DT::styleEqual(c('Higher', 'Lower'), c('tomato', 'seagreen'))
    )
  return(the_table)

}







