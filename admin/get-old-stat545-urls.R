# Recursively get ALL file paths that exist at the old https://stat545.com,
# created by the STAT545-UBC/STAT545-UBC.github.io repo.
#
# e.g. https://stat545.com/shiny_supp/2016/bdl-data-raw.csv
#      https://stat545.com/libs/bootstrap-3.3.5/css/cosmo.min.css
#      https://stat545.com/rstudio-workbench.png
#      https://block030_date-times.Rmd (auto-downloads)

library(gh)
library(stringr)
library(dplyr)
library(readr)
library(purrr)

response <- gh("GET /repos/:owner/:repo/git/trees/:tree_sha?recursive=1",
               owner = "STAT545-UBC",
               repo = "STAT545-UBC.github.io",
               tree_sha = "98ca77c") # last commit on master


stat545 <- response$tree %>% 
  keep(~.x$type == "blob") # we're only interested in files
  
  
paths <- vapply(stat545, "[[", "", "path")

stat545_urls <- tibble(
  old_url = "https://stat545.com/", 
  new_url = "https://STAT545-UBC.github.io/STAT545-UBC.github.io/",
  path = paths
)


write_csv(stat545_urls, "admin/old_stat545_urls.csv")
