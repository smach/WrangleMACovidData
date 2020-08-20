

#' Import MWRA sewage Covid-19 test data
#'
#' Data from http://www.mwra.com/biobot/biobotdata.htm. See mwra-data vignette for details. Default uses pdftables API (not free).
#'
#' @param mwra_sewage_pdf character string name of PDF downloaded from MWRA, or "none" if you are converting it to .xlsx another way.
#' @param covid_wastewater_file character string name of Excel file with data, either desired file to create or existing file.
#' @param latest_rda_file character string name of R data file where you'd like to save results
#' @param api_key pdftables API key if using. See https://pdftables.com/pdf-to-excel-api for more details
#'
#' @return List with 2 tibbles: Sewage test results by sample and by 3-sample average in North and South regions.
#' @export
#'
import_mwra_sewage_data <- function(mwra_sewage_pdf, covid_wastewater_file, latest_rda_file = paste0(Sys.getenv("COVID_DATA_DIR"), "sewage_data.Rdata"), api_key = Sys.getenv("pdftable_api")) {

if(mwra_sewage_pdf != "none") {

pdftables::convert_pdf(mwra_sewage_pdf, covid_wastewater_file, format = "xlsx-single")
}

  sewage <- suppressMessages(readxl::read_xlsx(covid_wastewater_file, sheet = 1, skip = 2) )
  names(sewage) <- c("SampleDate", "South", "North", "South7sample", "North7sample", "South3sample", "North3sample")

  sewage$SampleDate <- suppressWarnings(lubridate::mdy(sewage$SampleDate))
  sewage <- sewage %>%
    dplyr::filter(!is.na(North) & !is.na(South) & !is.na(South7sample) & !is.na(North7sample) & !is.na(South3sample) & !is.na(North3sample))

  south <- sewage[, c("SampleDate", "South3sample")]
  south$Region <- "South"
  names(south)[2] <- "Avg"
  north <- sewage[, c("SampleDate", "North3sample")]
  north$Region <- "North"
  names(north)[2] <- "Avg"
  sewage_3sample_data <- dplyr::bind_rows(south, north) %>%
    dplyr::filter(!is.na(Avg))




  #### Daily ####

  sewage_daily <- sewage

  sewage_daily <- sewage_daily[, c("SampleDate", "North", "South")]
  south <- sewage_daily[, c("SampleDate", "South")]
  south$Region <- "South"
  names(south)[2] <- "Avg"
  north <- sewage_daily[, c("SampleDate", "North")]
  north$Region <- "North"
  names(north)[2] <- "Avg"
  sewage_daily_data <- dplyr::bind_rows(south, north) %>%
    dplyr::filter(!is.na(Avg))


  save(sewage_3sample_data, sewage_daily_data, file = paste0(Sys.getenv("COVID_DATA_DIR"), "/sewage_data.Rdata") )
  my_results <- list(sewage_3sample_data, sewage_daily_data)
  names(my_results) <- c("sewage_3sample_data", "sewage_daily_data")
  return(my_results)
}
