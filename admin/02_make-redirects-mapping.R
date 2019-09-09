# Make master netlify redirects mapping csv and the _redirects file
# Redirect rules:
#  - Anything that is previous .html & is in bookdown -> redirect to bookdown
#  - Anything that is previous .html & NOT in bookdown -> redirect to gh pages
#  - Any static image files (.png), data files (.csv, .txt, .tsv), and .pdf files -> 
#    redirect to gh pages


library(readr)
library(dplyr)
library(glue)
library(fs)

old_urls <- read_csv("admin/old_stat545_urls.csv")
bookdown_urls <- read_csv("admin/bookdown_chp_urls.csv")


redirects_df <- left_join(old_urls, bookdown_urls, by = "stat545_path") %>%
  # redirect from...
  mutate(from = glue("/{stat545_path}")) %>% 
  # redirect to...
  mutate(to = if_else(!is.na(bookdown_path), # if a matching bookdown page exists
                      glue("/{bookdown_path}"), # to bookdown page
                      glue("{new_url}/{stat545_path}")) # otherwise, to gh pages
         ) %>%  
  # make formatting needed for _redirects
  # add 301 http status code to specify a permanent redirect
  mutate(formatted = glue("{from}    {to}    301"))


write_csv(redirects_df, "admin/redirects_mappings.csv")
write_lines(redirects_df$formatted, "_redirects")
