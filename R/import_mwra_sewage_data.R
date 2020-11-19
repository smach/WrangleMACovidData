

#' Import MWRA sewage Covid-19 test data
#'
#' Data from http://www.mwra.com/biobot/biobotdata.htm. See mwra-data vignette for details. Auto conversion of PDF to .xlsx uses the pdftables API (not free). Updated for Nov 2020 format but does not use error bars.
#'
#' @param mwra_sewage_file character string name of PDF downloaded from MWRA, or Excel spreadsheet if you already converted the PDF to .xlsx another way.
#' @param api_key pdftables API key if using. See https://pdftables.com/pdf-to-excel-api for more details
#'
#' @return data frame with MWRA Covid-19 data samples wrangled for use in ggplot2.
#' @export
#'
import_mwra_sewage_data <- function (mwra_sewage_file, api_key = Sys.getenv("pdftable_api"))
{
  if (grepl("pdf$", mwra_sewage_file)) {
    if (!requireNamespace("pdftables", quietly = TRUE)) {
      stop("Package \"pdftables\" needed for this function to work on a PDF. Please install it or convert the PDF to an .xlsx file some other way.",
           call. = FALSE)
    }
    covid_wastewater_file <- gsub(".pdf", ".xlsx",
                                  mwra_sewage_file, fixed = TRUE)
    pdftables::convert_pdf(mwra_sewage_file, covid_wastewater_file,
                           format = "xlsx-single")
  }
  else {
    covid_wastewater_file <- mwra_sewage_file
  }


  sewage <- suppressMessages(readxl::read_xlsx(covid_wastewater_file,
                                               sheet = 1, skip = 5))
  names(sewage) <- c("SampleDate", "South", "North", "South7sample", "North7sample", "SouthLowConfidence", "SouthHighConfidence", "NorthLowConfidence", "NorthHighConfidence")
  sewage$SampleDate <- suppressWarnings(lubridate::mdy(sewage$SampleDate))

  sewage_long <- tidyr::gather(sewage[, 1:5], key = "Region",
                               "DetectedCovid", 2:5) %>%
    dplyr::filter(!is.na(DetectedCovid)) %>%
    dplyr::mutate(
      SampleGroup = dplyr::case_when(
        stringr::str_detect(Region, "3sample") ~ "3sample",
        stringr::str_detect(Region,  "7sample") ~ "7sample",
        !(stringr::str_detect(Region, "sample")) ~ "eachsample")
    )
  sample_groups <- unique(sewage_long$SampleGroup)
  my_results <- split(sewage_long, f = sewage_long$SampleGroup)
  my_results$sample_groups <- sample_groups
  return(my_results)
}
