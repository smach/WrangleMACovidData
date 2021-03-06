% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{ma_geo}
\alias{ma_geo}
\title{sf geospatial file with data for Massachusetts cities and towns.}
\format{
A data frame with 352 rows and 6 variables:
\describe{
  \item{geoid}{census ID}
  \item{name}{Original place name}
  \item{geometory}{Polygon shapefile data}
  \item{Place}{Edited place name}
}
}
\source{
\url{https://censusreporter.org/data/table/?table=B00001&geo_ids=04000US25,160|04000US25&primary_geo_id=04000US25}
}
\usage{
ma_geo
}
\description{
This comes from US Census shapefile downloaded from CensusReporter.org
with a few alterations of place names to match Mass. Covid-19 data.
}
\keyword{datasets}
