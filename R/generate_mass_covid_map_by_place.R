

#' Generate a Leaflet map by community from MA weekly Covid-19 data
#'
#' @param the_map_data sf object created by macovid_read_weekly_for_map()
#' @param the_fill_palette palette created by leaflet::colorFactor()
#' @param the_labels HTML labels for popup
#' @param the_outline_color name of color to outline polygons; defaults to white
#'
#' @return leaflet object
#' @export
#'
#' @examples
generate_mass_covid_map_by_place <- function(the_map_data, the_fill_palette, the_labels, the_outline_color = "white") {
  the_map <- leaflet::leaflet(the_map_data) %>%
    leaflet::addPolygons(
      fillColor = the_fill_palette,
      weight = 1,
      opacity = 1,
      color = the_outline_color,
      dashArray = "3",
      fillOpacity = 0.7,
      highlight = leaflet::highlightOptions(
        weight = 2,
        color = "#666",
        dashArray = "",
        fillOpacity = 0.7,
        bringToFront = TRUE),
      label = the_labels,
      labelOptions = leaflet::labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto")
    )

  return(the_map)

}
