% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_mass_covid_map_by_place.R
\name{generate_mass_covid_map_by_place}
\alias{generate_mass_covid_map_by_place}
\title{Generate a Leaflet map by community from MA weekly Covid-19 data}
\usage{
generate_mass_covid_map_by_place(
  the_map_data,
  the_fill_palette,
  the_labels,
  the_outline_color = "white"
)
}
\arguments{
\item{the_map_data}{sf object created by macovid_read_weekly_for_map()}

\item{the_fill_palette}{palette created by leaflet::colorFactor()}

\item{the_labels}{HTML labels for popup}

\item{the_outline_color}{name of color to outline polygons; defaults to white}
}
\value{
leaflet object
}
\description{
See vignette("make-map", package = "WrangleMACovidData")
}
