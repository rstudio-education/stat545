# Creates a csv that links bookdown chapters url paths with the url path where 
# it was located on the previous `http://stat545.com`. When editing the bookdown
# GL recorded the previous locations of each bookdown chapter in html comments 
# that immediately followed the header, i.e. <!--Original content: <stat545-url>-->
# This script extracts those comments and constructs the corresponding bookdown
# url path using the cross reference labels in the headers (e.g. dplyr-intro, 
# dplyr-intro#basics)
# 
# The csv produced has two columns:
#
#  1. bookdown_path = the bookdown chapter url paths for the sections that contain content
#     that was on the previous stat545 site. 
#  2. stat545_path = the old stat45 site url paths where the matching content was found.
#     These urls were saved (by GL) in html comments that immediately follow the bookdown
#     header, i.e. <!--Original content: <stat545-url>-->
# -----------------------------------------------------------------------------

library(tibble)
library(readr)
library(dplyr)
library(purrr)
library(commonmark)
library(rvest)
library(stringr)
library(tidyr)
library(glue)
library(fs)

# helper function that render an Rmd as an HTML 
rmd_to_html <- function(rmd){

  html <- read_lines(rmd) %>% 
    markdown_html() %>% 
    read_html()
  return(html)
}

# helper function to scrape the chapters as html
filter_nodes <- function(html) {
  # pull out level 1 & 2 headers, and comments where GL recorded
  # the original stat545 page
  nodes <- html %>% 
    html_nodes(xpath = '//h1 | //h2 | //comment()[contains(., "Original content")]')
}


# helper function to create a pretty tibble with the name (h1, h2, comment)
# and actual text of each node
make_node_df <- function(nodeset){
  nodes_df <- tibble(
    name = html_name(nodeset),
    text = xml_text(nodeset)
  )
}


# make a list of all the chapter Rmds
chapters_rmd <- dir_ls(regexp = "[[:digit:]]{2}_.+[.]Rmd") %>% 
  discard(~ .x == "40_references.Rmd")

# convert the chapter Rmds to HTML
chapters_html <- map(chapters_rmd, rmd_to_html)

# scrape the chapter HTML for the nodes we want
nodes <- chapters_html %>% 
  # pull out only the h1, h2, and comment (w/ original url) nodes
  map(filter_nodes) %>%
  # make tibble with node name and contained text
  map(make_node_df) %>% 
  bind_rows()


# match up each header(s) with the matching comment  and nest the headers 
# when necessary, e.g. h1 -> comment, h1#h2 --> comment
paired_nodes <- nodes %>% 
  rowid_to_column(var = "index") %>% # to keep track of the order
  spread(name, text) %>% 
  
  select(index, h1, h2, comment) %>% 
  fill(h1) %>% 
  
  group_by(h1) %>% 
  fill(h2) %>% 
  ungroup() %>% 
  
  filter(!is.na(comment)) %>% 
  select(-index)

bookdown_urls <- paired_nodes %>% 
  # make the bookdown chapter url paths
  mutate(h1 = str_extract(h1, "(?<=\\{-?#).+(?=\\})"), # extract the ref labels for h2
         h1 = str_remove(h1, "\\s*[.]unnumbered$"),
         h1 = glue("{h1}.html")) %>%  # add .html to make the url path
  mutate(h2 = str_extract(h2, "(?<=\\{).+(?=\\})"), # extract the ref labels for h2
         h2 = if_else(is.na(h2), "", h2)) %>% # if it exists, add h2 to to the url path 
  mutate(bookdown_path = glue("{h1}{h2}")) %>% 
  select(-h1, -h2) %>% # clean up
  
  # extract the stat545 url paths from the html comments
  filter(str_detect(comment, "http(s?)://stat545.com")) %>% 
  mutate(stat545_path = str_extract(comment, "(?<=http(s?)://stat545.com/).*")) %>%  # discard base url
  select(-comment) %>%  # clean up 

  # don't redirect the automation slides bookdown page
  # since it already links out to the gh pages site
  filter(bookdown_path != "automation-slides.html")


write_csv(bookdown_urls, "admin/prev_stat545_to_bookdown.csv")
