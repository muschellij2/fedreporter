
[![Travis build status](https://travis-ci.org/muschellij2/fedreporter.svg?branch=master)](https://travis-ci.org/muschellij2/fedreporter) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/muschellij2/fedreporter?branch=master&svg=true)](https://ci.appveyor.com/project/muschellij2/fedreporter) [![Coverage status](https://coveralls.io/repos/github/muschellij2/fedreporter/badge.svg?branch=master)](https://coveralls.io/r/muschellij2/fedreporter?branch=master) <!-- README.md is generated from README.Rmd. Please edit that file -->

fedreporter Package:
====================

The goal of `fedreporter` is to provide downloads data from NIH 'ExPORTER'

Installation
------------

You can install `fedreporter` from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("muschellij2/fedreporter")
```

Example
=======

Project Search for R01s from NIH
--------------------------------

``` r
library(fedreporter)
res = fe_projects_search(
  project_number = "*R01*",
  fiscal_year = 2012,
  agency = "NIH",
  text = "stroke",
  text_field = "title")
#> GET command is:
#> Response [https://api.federalreporter.nih.gov/v1/Projects/search?query=projectNumber%3A*R01*%24fy%3A2012%24agency%3ANIH%24text%3Astroke%24textFields%3Atitle%24textOperator%3AAND&offset=1&limit=50]
#>   Date: 2017-10-03 15:31
#>   Status: 200
#>   Content-Type: application/json; charset=utf-8
#>   Size: 249 kB
names(res)
#> [1] "response" "content"
res$response
#> Response [https://api.federalreporter.nih.gov/v1/Projects/search?query=projectNumber%3A*R01*%24fy%3A2012%24agency%3ANIH%24text%3Astroke%24textFields%3Atitle%24textOperator%3AAND&offset=1&limit=50]
#>   Date: 2017-10-03 15:31
#>   Status: 200
#>   Content-Type: application/json; charset=utf-8
#>   Size: 249 kB
length(res$content)
#> [1] 4
names(res$content)
#> [1] "totalCount" "offset"     "limit"      "items"
res$content$offset
#> [1] 1
length(res$content$items)
#> [1] 50
```

Project Search for Individual PIs
---------------------------------

``` r
res = fe_projects_search(pi_name = "MATSUI, ELIZABETH")
#> GET command is:
#> Response [https://api.federalreporter.nih.gov/v1/Projects/search?query=piName%3AMATSUI%2C%20ELIZABETH&offset=1&limit=50]
#>   Date: 2017-10-03 15:31
#>   Status: 200
#>   Content-Type: application/json; charset=utf-8
#>   Size: 128 kB
items = res$content$items
con_pis = sapply(items, "[[", "contactPi")
keep = grepl("^MATSUI", con_pis)
items = items[keep]
mat_costs = sapply(items, "[[", "totalCostAmount")
sum(mat_costs)
#> [1] 16021336
                         
res = fe_projects_search(pi_name = "PENG, ROGER")
#> GET command is:
#> Response [https://api.federalreporter.nih.gov/v1/Projects/search?query=piName%3APENG%2C%20ROGER&offset=1&limit=50]
#>   Date: 2017-10-03 15:31
#>   Status: 200
#>   Content-Type: application/json; charset=utf-8
#>   Size: 55 kB
items = res$content$items
con_pis = sapply(items, "[[", "contactPi")
keep = grepl("^PENG", con_pis)
items = items[keep]
peng_costs = sapply(items, "[[", "totalCostAmount")
sum(peng_costs)
#> [1] 2868853
                         
# both = fe_projects_search(pi_name = c("MATSUI, ELIZABETH", "PENG, ROGER"))
```
