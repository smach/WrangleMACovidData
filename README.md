
<!-- README.md is generated from README.Rmd. Please edit that file -->

# WrangleMACovidData

<!-- badges: start -->

<!-- badges: end -->

The goal of WrangleMACovidData is to create user-friendly maps and
tables from Massachusetts Department of Public Health Covid-19 data. For
now, the package can perform two tasks:

1)  Generate choropleth maps by community with data by testing
    positivity rates in the past 14 days or average daily new known
    cases per 100K in the past 14 days

2)  Generate a searchable, sortable HTML table of data by community.

## Installation

Because the spreadsheet data format changes fairly frequently, I don’t
expect this package to ever be on CRAN. Instead, install
from[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("smach/WrangleMACovidData")
```

# Examples

To generate the HTML table, you just need to run
`generate_html_table_by_place("Weekly_Dashboard_Data.xlsx")`.

For information on creating a map, please see the how to make a map
vignette. After the package is installed, run `vignette("make-map",
package = "WrangleMACovidData")`.
