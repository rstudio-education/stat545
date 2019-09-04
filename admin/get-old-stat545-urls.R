# Get all html files that could be found on the "old" https://stat545.com that
# was created by the STAT545-UBC/STAT545-UBC.github.io repo 

library(gh)
library(stringr)
library(dplyr)
library(readr)
library(purrr)

stat545 <- gh("GET /repos/:owner/:repo/contents", 
              owner = "STAT545-UBC",
              repo = "STAT545-UBC.github.io")

files <- vapply(stat545, "[[", "", "name")

html_files <- files %>% 
  discard(!str_detect(., "\\.html$"))


refs <- tibble(
  old_url = "https://stat545.com/", 
  new_url = "https://STAT545-UBC.github.io/STAT545-UBC.github.io/",
  html_file = html_files
)


write_csv(refs, "admin/old_stat545_urls.csv")

