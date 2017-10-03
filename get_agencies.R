library(rvest)
library(xml2)
url = "https://api.federalreporter.nih.gov/html/Agencies.html"
doc = read_html(url)
tabs = html_nodes(doc, xpath = "//table")
tab = html_table(tabs[[1]])
tab = as.character(unlist(tab, recursive = TRUE))
tab = unique(tab)
tab = unlist(sapply(strsplit(tab, ","), trimws))
tab = sort(tab)
fe_agencies = tab
save(fe_agencies,
     file = "data/fe_agencies.rda",
     compression_level = 9)
