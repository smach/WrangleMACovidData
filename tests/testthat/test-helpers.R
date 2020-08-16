library(WrangleMACovidData)
weekly_dashboard_file <- system.file("extdata", "Weekly-Dashboard-data-08122020.xlsx", package = "WrangleMACovidData")
data <- macovid_read_weekly_for_map(weekly_dashboard_file)
library(testthat)

pull_category <- function(the_place, thedf = data) {
  as.character(thedf[["CaseCategory"]][thedf[["Place"]] == the_place] )
}


pull_positivity_category <- function(the_place, thedf = data) {
  as.character(thedf[["PositivityCategory"]][thedf[["Place"]] == the_place] )
}

test_that("category_assignments", {
  expect_equal(pull_category("Framingham"), "Yellow")
  expect_equal(pull_category("Chelsea"), "Red")
  expect_equal(pull_category("Natick"), "Green")
  expect_equal(pull_category("Lenox"), "White")
})

test_that("positivity_assignments", {
   expect_equal(pull_positivity_category("Framingham"), "Low")
  expect_equal(pull_positivity_category("Saugus"), "Moderate")
  expect_equal(pull_positivity_category("Holyoke"), "Low")
  expect_equal(pull_positivity_category("Russell"), "Very High")
  expect_equal(pull_positivity_category("Lynn"), "High")
})

labels <- glue::glue("<strong>{data$Place}</strong><br/>Positivity: {data$PositivityRate}%<br />Avg daily cases per 100K: {data$DailyAvgCases}") %>%
  lapply(htmltools::HTML)
names(labels) <- data$Place

pull_positivity <- function(the_place, the_label = labels) {
  as.numeric(stringr::str_replace(the_label[[the_place]], "^.*?Positivity:\\s(.*?)\\%.*$", "\\1"))

}


test_that("positivity number", {
  test_that(pull_positivity("Framigham"), 2.2)
  test_that(pull_positivity("Pembroke"), 1.8)
  test_that(pull_positivity("Orleans"), 0)
  test_that(pull_positivity("Foxoborough"), 0.4)
})
