# Recursively get all file paths that exist at the old https://stat545.com,
# created by the STAT545-UBC/STAT545-UBC.github.io repo.
#
# e.g. https://stat545.com/shiny_supp/2016/bdl-data-raw.csv
#      https://stat545.com/libs/bootstrap-3.3.5/css/cosmo.min.css
#      https://stat545.com/rstudio-workbench.png
#      https://stat545.com/block030_date-times.Rmd (auto-download)

library(gh)
library(stringr)
library(dplyr)
library(readr)
library(purrr)

response <- gh("GET /repos/:owner/:repo/contents",
               owner = "STAT545-UBC",
               repo = "STAT545-UBC.github.io")


stat545_path <- vapply(response, "[[", "", "name")
stat545_path_type <- vapply(response, "[[", "", "type")


stat545_urls <- tibble(
  old_url = "https://stat545.com", 
  new_url = "https://STAT545-UBC.github.io/STAT545-UBC.github.io",
  stat545_path, 
  stat545_path_type
)

write_csv(stat545_urls, "admin/old_stat545_urls.csv")
