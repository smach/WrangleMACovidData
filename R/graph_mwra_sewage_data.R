


#' Generate interactive plotly graph of MWRA sewage testing data
#'
#' Data from http://www.mwra.com/biobot/biobotdata.htm generated by import_mwra_sewage_data() function. See mwra-data vignette for details.
#'
#' @param mydf dataframe of MWRA sewage test data from import_mwra_sewage_data()
#' @param mytitle character string of desired graph title
#'
#' @return plotly graph
#' @export
#'
graph_sewage_data <- function(mydf, mytitle = "") {
  plotly::ggplotly(
    ggplot2::ggplot(mydf, ggplot2::aes(x = SampleDate, y = DetectedCovid, colour = Region, Group = Region)) +
      ggplot2::geom_line() +
      ggplot2::geom_point() +
      ggplot2::scale_color_manual(values = c("#377eb8", "#4daf4a")) +
      ggplot2::xlab("") +
      ggplot2::ylab("RNA copies/mL") +
      ggplot2::theme_minimal() +
      ggplot2::scale_x_date(date_breaks = "28 days", date_labels = "%b %e") +
      ggplot2::labs(title = mytitle)
  )

}
