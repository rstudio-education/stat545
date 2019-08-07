  [![Travis build status](https://travis-ci.org/rstudio-education/stat545-reboot.svg?branch=master)](https://travis-ci.org/rstudio-education/stat545-reboot) [![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![Netlify Status](https://api.netlify.com/api/v1/badges/82ff5a18-8a13-4f25-b688-230b04bc5664/deploy-status)](https://app.netlify.com/sites/gracious-allen-b2d17f/deploys)

This bookdown book is a *work in progress*. We'll update this `README` and the repo status when ready! :rocket:


# Requirements to preview the bookdown locally 

## OMDb API Key

1. Request an API key [here](https://www.omdbapi.com/apikey.aspx)
1. Check your email and follow the instructions to activate your key
1. Add the API key to your `.Renviron` file. First, open your .`Renviron` file:
  
    ```{r eval = FALSE}
    library(usethis)
    edit_r_environ()
    ```
    
    Next, add `OMDB_API_KEY=<your-key>` on a new line, replacing `<your-key>` with your OMDb key. (Make sure to have your `.Renviron` file end on a new line!)
    
## Required packages

```r
pkg_list <- c("bookdown", "dichromat", "DT", "gapminder", "gender", "geonames",
              "git2r", "glue", "gridExtra", "htmltools", "httr", "knitr", 
              "RColorBrewer", "rebird", "rmarkdown", "roxygen2", "rplos",
              "rvest", "testthat", "tidyverse", "units", "viridis", "xml2",
              "r-lib/fs", "r-lib/usethis", "r-lib/devtools", 
              "ropensci/genderdata", "rstudio/gt", "yihui/xfun")
```

Here's one way to install the needed packages (only the ones that you don't already have) using the [`pak` package][pak-web]:

```r
if (!require("pak")) install.packages("pak")
pak::pkg_install(pkg_list)
```

<!--TODO: Add a second option using the `renv` package. -->


    