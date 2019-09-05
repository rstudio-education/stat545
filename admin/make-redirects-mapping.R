# Make master netlify redirects mapping csv
library(readr)
library(dplyr)
library(glue)

old_urls <- read_csv("admin/old_stat545_urls.csv")
bookdown_urls <- read_csv("admin/bookdown_chp_urls.csv")

redirects_df <- left_join(old_urls, bookdown_urls, by = "stat545_path") %>% 
  mutate(in_bookdown = !is.na(bookdown_path)) %>% 
  mutate(from = if_else(stat545_path_type == "file",
                        glue("/{stat545_path}"),
                        glue("/{stat545_path}/*")),
         to = if_else(in_bookdown, 
                      glue("/{bookdown_path}"),
                      if_else(stat545_path_type == "dir",
                              glue("{new_url}/{stat545_path}/:splat"),
                              glue("{new_url}/{stat545_path}"))),
         formatted = glue("{from}    {to}    301")) %>% 
  arrange(formatted)  # to make it easier to read

write_csv(redirects_df, "admin/redirects_mappings.csv")
write_lines(redirects_df$formatted, "_redirects")
