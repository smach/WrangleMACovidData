


#' Read weekly Mass Covid dashboard to join with shapefile for mapping
#'
#' @param weekly_data_file Weekly Covid-19 spreadsheet from Mass Dept of Public Health
#' @param gis_data sf object available in this package
#'
#' @return sf object for use in making a Leaflet map
#' @export
#'
macovid_read_weekly_for_map <- function(weekly_data_file, gis_data = ma_geo) {
  ma_data <- readxl::read_xlsx(weekly_data_file, sheet = "City_Town_Data")
  ma_data <- ma_data %>%
    dplyr::mutate(
      `Percent positivity` = readr::parse_number(`Percent positivity`),
      `Total case count` = readr::parse_integer(`Total case count`),
      `Two Week Case Count` = readr::parse_integer(`Two Week Case Count`),
      PositivityRate = round(`Percent positivity` * 100, 1),
      PositivityCategory = get_positivity_category(PositivityRate) ,
      DailyAvgCases = ifelse(`Average Daily Incidence Rate per 100000` == "<5", NA,
                             round(readr::parse_number(`Average Daily Incidence Rate per 100000`), 1)) ,
      CaseCategory = get_cases_category(DailyAvgCases)
    )

  ma_data$PositivityCategory <- factor(ma_data$PositivityCategory, levels = c("Ideal", "Very Low", "Low", "Moderate", "Concern", "High", "Very High"), ordered = TRUE)

  ma_data$CaseCategory <- factor(ma_data$CaseCategory, levels = c("White", "Green", "Yellow", "Red"), ordered = TRUE)

  names(ma_data)[1] <- "Place"
  ma_data$Place <- stringr::str_replace(ma_data$Place, "Manchester", "Manchester-by-the-Sea")


  map_data <- dplyr::left_join(gis_data, ma_data, by = "Place") %>%
    filter(name != "Massachusetts")

  return(map_data)
}
