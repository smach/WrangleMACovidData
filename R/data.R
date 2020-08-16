#' sf geospatial file with data for Massachusetts cities and towns.
#'
#' This comes from US Census shapefile downloaded from CensusReporter.org
#' with a few alterations of place names to match Mass. Covid-19 data.
#'
#' @format A data frame with 352 rows and 6 variables:
#' \describe{
#'   \item{geoid}{census ID}
#'   \item{name}{Original place name}
#'   \item{geometory}{Polygon shapefile data}
#'   \item{Place}{Edited place name}
#' }
#' @source \url{https://censusreporter.org/data/table/?table=B00001&geo_ids=04000US25,160|04000US25&primary_geo_id=04000US25}
"ma_geo"



#' case_palette color palette for use with MA Covid cases per 100K
#'
#' Attempt to somewhat mimic Mass DPH color scheme
#'
#' @format A vector of colors


#' positivity_palette leaflet palette for use with MA Covid test positivity rates
#'
#' @format A vector of colors
#'
#'

