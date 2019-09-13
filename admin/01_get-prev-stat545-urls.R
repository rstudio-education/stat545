# Get file paths that exist at the previous https://stat545.com that was 
# created by the STAT545-UBC/STAT545-UBC.github.io repo. Only keep file 
# paths that end with .html, .csv, .txt, .tsv, .png, .pdf. Everything else
# will be automatically redirected to 404 by Netlify.
# -----------------------------------------------------------------------------

library(gh)
library(dplyr)
library(readr)
library(purrr)
library(fs)


# get the contents of the github repo 
response <- gh("GET /repos/:owner/:repo/contents",
               owner = "STAT545-UBC",
               repo = "STAT545-UBC.github.io")


# filter the response
stat545_paths <- response %>% 
  keep(~.x$type == "file") %>% # only keep files, discard directories
  vapply("[[", "", "path") # extract the file path


# create a tibble with the file paths as fs path objects
stat545_urls <- tibble(
  stat545_path = fs_path(stat545_paths)
)


# only interested in redirecting paths ending with these exts
to_keep <- c("html", "csv", "txt", "tsv", "png", "pdf")
# don't redirect these paths
to_ignore <- c("404.html", "index.html")


# only keep the url paths we are going to redirect
urls_filtered <- stat545_urls %>% 
  mutate(stat545_ext = path_ext(stat545_path)) %>% # separate the ext from the url path
  filter(stat545_ext %in% to_keep) %>%  # only keep the url paths we care about
  filter(!stat545_path %in% to_ignore) %>% # don't redirect these
  select(-stat545_ext)


write_csv(urls_filtered, "admin/prev_stat545_urls.csv")
