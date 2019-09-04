# Link the cross-reference labels for bookdown chapters (if they exist) with 
# content that was on the old stat545.com. Creates a csv that links the 
# bookdown reference links to the old stat545.com url.

library(readr)
library(dplyr)
library(purrr)
library(commonmark)
library(rvest)
library(stringr)
library(tidyr)

# helper-functions --------------------------------------------------------
rmd_to_html <- function(rmd){
  html <- read_lines(rmd) %>% 
    markdown_html() %>% 
    read_html()
  return(html)
}

filter_nodes <- function(htmls) {
  nodeset <- htmls %>% 
    html_nodes(xpath = '//h1 | //h2 | //comment()[contains(., "Original content")]') %>% 
    xml_text() %>% 
    discard(!str_detect(., "(\\.html)|(\\{-?#)"))
}
# -----------------------------------------------------------------------------

chapters_rmd <- list.files(path = ".", pattern = "[[:digit:]]{2}_.*\\.Rmd") %>% 
  discard(~ .x == "40_references.Rmd")

chapters_html <- map(chapters_rmd, rmd_to_html)

filtered_nodes <- chapters_html %>% 
  map(filter_nodes) %>% 
  flatten_chr()

paired_nodes <- tibble(
  header = filtered_nodes, 
  url = filtered_nodes[-1] %>% 
    append(NA_character_)
  )

bookdown_urls <- paired_nodes %>% 
  filter(str_detect(header, "\\{-?#") & str_detect(url, "http")) %>% 
  mutate(title = str_extract(header, ".+(?=\\{)"),
         ref_label = str_extract(header, "\\{-?#.+\\}")) %>% 
  select(-header) %>% 
  mutate(url = str_extract(url, "(?<=Original content: ).+"),
         base_url = str_extract(url, ".+\\.com/"),
         html_file = str_extract(url, "(?<=\\.com/).+")) %>% 
  select(-url)
  
  

write_csv(bookdown_urls, "admin/bookdown_chp_urls.csv")



