# Make master netlify redirects mapping csv and the _redirects file
# Redirect rules:
#  - Anything that is previous .html and...
#     - in bookdown --> redirect to bookdown
#     - in happygitwithr --> redirect to happygitwithr
#     - not in bookdown or happygitwithr -->  redirect to gh pages
#  - Any static image files (.png), data files (.csv, .txt, .tsv), and .pdf files -> 
#    redirect to gh pages
# -----------------------------------------------------------------------------

library(readr)
library(dplyr)
library(glue)
library(fs)

prev_urls <- read_csv("admin/prev_stat545_urls.csv")
bookdown_mappings <- read_csv("admin/prev_stat545_to_bookdown.csv")
happygit_mappings <- read_csv("admin/prev_stat545_to_happygit.csv")


gh_pages_url <- "https://STAT545-UBC.github.io/STAT545-UBC.github.io"
happygit_url <- "https://happygitwithr.com"


redirects_df <- prev_urls %>% 
  left_join(bookdown_mappings, by = "stat545_path") %>% # join in bookdown mappings
  left_join(happygit_mappings, by = "stat545_path") %>% # join in happygit mappings
  
  # redirect from...
  mutate(from = glue("/{stat545_path}")) %>% 
    
  # redirect to...
  mutate(to = if_else(!is.na(bookdown_path), # if a matching bookdown page exists...
                      glue("/{bookdown_path}"), # -> bookdown page
                      if_else(!is.na(happygit_path), # if a matching hg page exists...
                              glue("{happygit_url}/{happygit_path}"), # -> happygit
                              glue("{gh_pages_url}/{stat545_path}")))) %>% 

  # format for _redirects & add 301 http status code for permanent redirect
  mutate(formatted = glue("{from}    {to}    301"))


write_csv(redirects_df, "admin/redirects_mappings.csv")
write_lines(redirects_df$formatted, "_redirects")
