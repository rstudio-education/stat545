# Make master netlify redirects mapping csv
library(readr)
library(dplyr)
library(stringr)

old_urls <- read_csv("admin/old_stat545_urls.csv")
bookdown_urls <- read_csv("admin/bookdown_chp_urls.csv")


redirects_df <- left_join(old_urls, bookdown_urls, by = "stat545_path") %>% 
  arrange(bookdown_path) %>% 
  mutate(in_bookdown = if_else(!is.na(bookdown_path),
                               TRUE, FALSE)) %>% 
  mutate(from = if_else(stat545_path_type == "file",
                        str_c("/", stat545_path),
                        str_c("/", stat545_path, "/*")
                        ),
         to = if_else(in_bookdown, 
                      str_c("/", bookdown_path),
                      if_else(stat545_path_type == "dir",
                              str_c(new_url, "/", stat545_path, "/:splat"),
                              str_c(new_url, "/", stat545_path)
                              )
                      ),
         formatted = str_c(from, "\t", to, "\t", "301"))
  

write_csv(redirects_df, "admin/redirects_mappings.csv")
write_lines(redirects_df$formatted, "_redirects")

