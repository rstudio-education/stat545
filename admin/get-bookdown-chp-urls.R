# Link the cross-reference labels for bookdown chapters (if they exist) with 
# content that was on the old stat545.com. Creates a csv that links the 
# bookdown html paths to the old stat545.com site.

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

filter_nodes <- function(html) {
  nodes <- html %>% 
    html_nodes(xpath = '//h1 | //h2 | //comment()[contains(., "Original content")]')
}

make_node_df <- function(nodeset){
  nodes_df <- tibble(
    name = html_name(nodeset),
    text = xml_text(nodeset)
  )
}
# -----------------------------------------------------------------------------


chapters_rmd <- list.files(path = ".", pattern = "[[:digit:]]{2}_.*\\.Rmd") %>% 
  discard(~ .x == "40_references.Rmd")

chapters_html <- map(chapters_rmd, rmd_to_html)

nodes <- chapters_html %>% 
  map(filter_nodes) %>% 
  map(make_node_df) %>% 
  bind_rows()


paired_nodes <- nodes %>% 
  mutate(index = row_number()) %>% 
  spread(name, text) %>% 
  
  select(index, h1, h2, comment) %>% 
  fill(h1) %>% 
  
  group_by(h1) %>% 
  fill(h2) %>% 
  ungroup() %>% 
  
  filter(!is.na(comment)) %>% 
  select(-index)

bookdown_urls <- paired_nodes %>% 
  # clean up bookdown ref urls
  mutate(h1 = str_extract(h1, "(?<=\\{-?#).+(?=\\})"),
         h1 = str_c(h1, ".html")) %>% 
  mutate(h2 = str_extract(h2, "(?<=\\{).+(?=\\})"),
         h2 = if_else(is.na(h2), "", h2)) %>% 
  mutate(bookdown_path = str_c(h1, h2)) %>% 
  select(-h1, -h2) %>% 
  
  # clean up stat545 urls
  filter(str_detect(comment, "http(s?)://stat545.com")) %>% 
  mutate(stat545_path = str_extract(comment, "(?<=http(s?)://stat545.com/).*")) %>% 
  select(-comment)


# TODO: fix automation slides link, currently links out to the github.io stat545 site.
bookdown_urls <- bookdown_urls %>% 
  filter(bookdown_path != "automation-slides.html")


write_csv(bookdown_urls, "admin/bookdown_chp_urls.csv")
