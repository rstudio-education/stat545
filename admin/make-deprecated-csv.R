# Creates a csv file with the title, url path, and year last updated for 
# all deprecated content. Used in the Appendix to create a gt table. 

library(readr)
library(dplyr)

deprecated <- tribble(
  ~title, ~stat545_path, ~last_updated,
  "Vectors versus tibbles", "block031_vector-tibble-relations.html", "2016",
  "Computing by groups within data.frames with dplyr and broom", "block023_dplyr-do.html", "2016",
  "Be the boss of your factors (2015)", "block014_factors.html", "2016",
  "Regular expressions and character data (2015)", "block027_regular-expressions.html", "2015", 
  "Write your own R package, part 1 (2014)", "packages02_activity.html", "2015",
  "Write your own R package, part 2 (2014)", "packages03_activity_part2.html", "2015",
  "Computing by groups within data.frames with plyr", "block013_plyr-ddply.html", "2015",
  "Wrapping lm", "block025_lm-poly.html", "2015",
  "Regular expressions in R (2014)", "block022_regular-expression.html", "2015"
  
)

write_csv(deprecated, "admin/deprecated_stat545_urls.csv")

