


get_positivity_category <- function(positivity) {
  the_category <- dplyr::case_when(
    positivity <= 1 ~ "Ideal",
    positivity > 1 & positivity <= 2 ~ "Very Low",
    positivity > 2 & positivity <= 3 ~ "Low",
    positivity > 3 & positivity <= 4 ~ "Moderate",
    positivity > 4 & positivity <= 5 ~ "Concern",
    positivity > 5 & positivity <= 10  ~ "High",
    positivity > 10  ~ "Very High"
  )

  return(the_category)
}

# my_colors <- c("#2B9C8E", "#51B785", "#C5D792", "#ECC686", "#ECA376", "#BD3427" )

# mypalette <- leaflet::colorFactor(my_colors, levels = c("Ideal", "Very Low", "Low", "Moderate", "Concern", "High", "Very High"), ordered = TRUE)


# my_colors_cases <- c("#FFFFFF", "#236552", "#FAC441", "#BD3427")

# mypalette_cases <- leaflet::colorFactor(my_colors_cases, levels = c("White", "Green", "Yellow", "Red"), ordered = TRUE)


#  1 White:<5 reported cases in the last 14 days; Green:
# Average daily case rate over the last 14 days: <4 cases per 100,000 population; Yellow: Average daily case rate over the last 14 days: 4-8 cases per 100,000 population; Red: Average daily case rate
# over the last 14 days: >8 cases per 100,000 population.

get_cases_category <- function(cases) {
  the_category <- dplyr::case_when(
    cases == 0 | is.na(cases) ~ "White",
    cases > 0 & cases < 4 ~ "Green",
    cases >= 4 & cases <= 8 ~ "Yellow",
    cases > 8 ~ "Red"
  )
  return(the_category)
}
