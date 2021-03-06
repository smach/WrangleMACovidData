


#' Read weekly Mass Covid dashboard to join with shapefile for mapping
#'
#' See vignette("make-map", package = "WrangleMACovidData") for more info
#'
#' @param weekly_data_file character string Weekly Covid-19 spreadsheet from Mass Dept of Public Health
#' @param the_sheet character string sheeet name for weekly file
#'
#' @return sf object for use in making a Leaflet map
#' @export
#'
macovid_read_weekly_for_map <- function(weekly_data_file, the_sheet = "City_town") {
  ma_data <- readxl::read_xlsx(weekly_data_file, sheet = the_sheet)
  if(length(names(ma_data)) == 10) {
    names(ma_data) <- c("Place", "Cases", "CasesLast14Days", "AvgDailyPer100K", "RelativeChange", "TotalTested", "TotalTestedLast14Days", "TotalPositiveLast14Days", "PctPositive", "ChangePctPositivity")
  } else if (length(names(ma_data)) == 16) {
    names(ma_data) <- c("Place", "County", "Population", "Cases", "CasesLast14Days", "AvgDailyPer100K", "ChangeLastWeek", "TotalTested", "TotalTestedLast14Days", "TotalPositiveLast14Days", "PctPositive", "ChangePctPositivity", "TestingRate", "ReportDate", "StartDate", "EndDate")

  }




  gis_file <- system.file("extdata", "MA_shapefile/acs2018_5yr_B00001_06000US2502141515.shp", package = "WrangleMACovidData")
  ma_data <- ma_data %>%
    dplyr::mutate(
      `Percent positivity` = fix_characters(`PctPositive`),
      `Total case count` = fix_characters(`Cases`, "integer"),
      `Two Week Case Count` = fix_characters(`CasesLast14Days`, "integer" ),
      PositivityRate = round(`Percent positivity` * 100, 1),
      PositivityCategory = get_positivity_category(PositivityRate) ,
      DailyAvgCases = ifelse(AvgDailyPer100K == "<5", NA,
                             round(suppressWarnings(readr::parse_number(AvgDailyPer100K) ), 1)) ,
      CaseCategory = get_cases_category(DailyAvgCases),
      `Total case count` = as.vector(`Total case count`),
      `Two Week Case Count` = as.vector(`Two Week Case Count`),
      `Percent positivity` = as.vector(`Percent positivity`),
      PositivityRate = as.vector(PositivityRate)
    )

  ma_data$PositivityCategory <- factor(ma_data$PositivityCategory, levels = c("1.0 or Below", "Very Low", "Low", "Moderate", "Concern", "High", "Very High"), ordered = TRUE)

  ma_data$CaseCategory <- factor(ma_data$CaseCategory, levels = c("White", "Green", "Yellow", "Red"), ordered = TRUE)

  names(ma_data)[1] <- "Place"
  ma_data$Place <- stringr::str_replace(ma_data$Place, "Manchester", "Manchester-by-the-Sea")

  ma_data <- as.data.frame(ma_data)
  ma_geo <- sf::st_read(gis_file, stringsAsFactors = FALSE)
  ma_geo$Place <- stringr::str_replace(ma_geo$name, "(^.*?) town.*?$", "\\1")
  ma_geo$Place <- stringr::str_replace(ma_geo$Place, "(^.*?) city.*?$", "\\1")
  ma_geo$Place <- stringr::str_replace(ma_geo$Place, "(^.*?) City.*?$", "\\1")
  ma_geo$Place <- stringr::str_replace(ma_geo$Place, "(^.*?) Town.*?$", "\\1")
  ma_geo$Place <- stringr::str_replace(ma_geo$Place, "Massachusetts", "State")

  map_data <- dplyr::left_join(ma_geo, ma_data, by = "Place") %>%
    dplyr::filter(name != "Massachusetts")


  return(map_data)
}
