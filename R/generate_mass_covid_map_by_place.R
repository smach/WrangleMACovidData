

#' Generate a Leaflet map by community from MA weekly Covid-19 data
#'
#' @param the_map_data sf object created by macovid_read_weekly_for_map()
#' @param the_fill_color
#' @param the_labels
#' @param the_outline
#'
#' @return
#' @export
#'
#' @examples
generate_mass_covid_map_by_place <- function(the_map_data, the_fill_color, the_labels, the_outline = "white") {
  the_map <- leaflet::leaflet(the_map_data) %>%
    leaflet::addPolygons(
      fillColor = the_fill_color,
      weight = 1,
      opacity = 1,
      color = the_outline,
      dashArray = "3",
      fillOpacity = 0.7,
      highlight = highlightOptions(
        weight = 2,
        color = "#666",
        dashArray = "",
        fillOpacity = 0.7,
        bringToFront = TRUE),
      label = the_labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto")
    )

  return(the_map)

}
