

#' Import MWRA sewage Covid-19 test data
#'
#' Data from http://www.mwra.com/biobot/biobotdata.htm. See mwra-data vignette for details. Auto conversion of PDF to .xlsx uses the pdftables API (not free).
#'
#' @param mwra_sewage_file character string name of PDF downloaded from MWRA, or Excel spreadsheet if you already converted the PDF to .xlsx another way.
#' @param api_key pdftables API key if using. See https://pdftables.com/pdf-to-excel-api for more details
#'
#' @return data frame with MWRA Covid-19 data samples wrangled for use in ggplot2.
#' @export
#'
import_mwra_sewage_data <- function(mwra_sewage_file, api_key = Sys.getenv("pdftable_api")) {

if(grepl("pdf$", mwra_sewage_file)) {
  if (!requireNamespace("pdftables", quietly = TRUE)) {
    stop("Package \"pdftables\" needed for this function to work on a PDF. Please install it or convert the PDF to an .xlsx file some other way.",
         call. = FALSE)
  }
  pdftables::convert_pdf(mwra_sewage_file, covid_wastewater_file, format = "xlsx-single")
  covid_wastewater_file <- stringr::str_replace(mwra_sewage_file, "pdf", "xlsx")
} else {
  covid_wastewater_file <- mwra_sewage_file
}

  check_columns <- readxl::read_xlsx(covid_wastewater_file, sheet = 1, n_max = 3)
  new_names <- c("SampleDate", as.character(check_columns[1,2]), as.character(check_columns[1,3]) )
  new_names <- stringr::str_replace_all(new_names, "ern", "")
  for(i in 4:ncol(check_columns)) {
    new_names[i] = paste0(names(check_columns[i]),check_columns[1, i] )
    new_names[i] = stringr::str_replace_all(new_names[i], "ern", "")
    new_names[i] = stringr::str_replace_all(new_names[i], " ", "")
  }


  sewage <- suppressMessages(readxl::read_xlsx(covid_wastewater_file, sheet = 1, skip = 2) )
  # names(sewage) <- c("SampleDate", "South", "North", "South7sample", "North7sample", "South3sample", "North3sample")
  names(sewage) <- new_names

  sewage$SampleDate <- suppressWarnings(lubridate::mdy(sewage$SampleDate))
  sewage_long <- tidyr::gather(sewage, key = "Region", "DetectedCovid", 2:ncol(sewage)) %>%
    dplyr::filter(!is.na(DetectedCovid)) %>%
    dplyr::mutate(
      SampleGroup = dplyr::case_when(
        stringr::str_detect(Region, "3sample") ~ "3sample",
        stringr::str_detect(Region, "7sample") ~ "7sample",
        !(stringr::str_detect(Region, "sample")) ~ "eachsample"
      )
    )

sample_groups <- unique(sewage_long$SampleGroup)

my_results <- split(sewage_long , f = sewage_long$SampleGroup )

my_results$sample_groups <- sample_groups
  return(my_results)
}
