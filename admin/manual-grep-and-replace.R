library(tidyverse)

# this was a fairly manual and iterative process, but if we ever need to do
# similar again, this code provides a head start

# grep -oh -d skip -e '\s`[[:alnum:]]*`\s' ./* > grep-results.txt
# rm grep-results.txt

x <- read_lines("grep-results.txt") %>% str_trim()

remove_me <- c(
  "x", "make", "Makefile", "devtools", "all", "input", "country",
  "filtered", "output", "clean", "gdpPercap", "server", "table",
  "y", "continent", "n", "NA", "ui", "l", "NULL", "priceDiff",
  "session", "for", "lifeExp", "PATH", "pop", "cp", "gdpPercapRel",
  "git", "i", "inputId", "p", "renderPlot", "typeInput", "value",
  "00", "100", "asia", "bb", "bin", "by", "bytes", "camelCase",
  "condition", "conditionalPanel", "countryInfo", "colorschemes",
  "compress", "ebirdgeo",
  # the ones that are left are legit
  "gapminder", "curl"
)
x %in% glue("`{remove_me}`") %>% table()
x <- x[!x %in% glue("`{remove_me}`")]

tibble(x = x) %>% 
  count(x, sort = TRUE) %>% 
  View()

