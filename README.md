<a alt = "TravisCI Build Status" href="https://travis-ci.org/rstudio-education/stat545"><img src="https://travis-ci.org/rstudio-education/stat545.svg?branch=master" height = 20 /></a>
<a alt = "Netlify Deployments" href="https://app.netlify.com/sites/stat545-book/deploys"><img src="https://api.netlify.com/api/v1/badges/22cbd49d-9d4d-462f-9d28-a797fa14a11d/deploy-status" height = 20 /></a>
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" height = 20 /></a>
<a alt = "Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public." href="http://www.repostatus.org/#wip"><img src="http://www.repostatus.org/badges/latest/wip.svg" height = 20 /></a>

This bookdown book is a *work in progress*. We'll update this `README` and the repo status when ready! :rocket:

# Requirements to preview the site locally 

Install the required packages.

## Option 1: Use renv for a project-specific library

This is how we work locally and on Travis-CI, where the public product is actually built and deployed.

The [renv package](https://rstudio.github.io/renv/index.html) uses a [snapshot and restore](https://environments.rstudio.com/snapshot.html) strategy to create **r**eproducible **env**vironments for R projects. A project that uses renv has
its own project-specific library that is separate from your personal library of packages. This helps contributors ensure we're all using the same version of packages and that the public site is also being built from these versions.

1. Get a local copy of the website source.
   * Users of devtools/usethis can do:
     ```r
     usethis::create_from_github("rstudio-education/stat545")
     ```
     Note that `usethis::create_from_github()` works best when it can find a
     GitHub personal access token and usethis (git2r, really) is configured
     correctly for your preferred transport protocol (SSH vs HTTPS).
     [Setup advice](https://usethis.r-lib.org/articles/articles/usethis-setup.html).
   * Otherwise, use your favorite method to fork and clone or download the
     repo as a ZIP file and unpack.
1. Start R in your new `stat545/` directory. Expect to see some renv startup
   along these lines:
   ```
   Failed to find installation of renv -- attempting to bootstrap...
   * Downloading renv 0.7.0-50 ... Done!
   * Installing renv 0.7.0-50 ... Done!
   Successfully installed and loaded renv 0.7.0-50.
   * Project '~/tmp/stat545' loaded. [renv 0.7.0-50]
   ```
1. Run `renv::restore()`. This will print out "The following package(s) will be
   installed" followed by a long list of packages. Respond "yes". renv will
   build the project-specific library containing packages at the correct
   versions.
1. You should now be able to render the site in all the usual ways for bookdown,
   such as `bookdown::render_book()` or *Addins > Preview Book*.
    
## Option 2: Use pak or similar

If the renv infrastructure is confusing to you, use `renv::deactivate()` to remove it. You could then use your favorite method of package installation to make sure you've got the necessary packages (although there's no guarantee that you're using the same version as we are).

Here's one way to install the needed packages (only the ones that you don't already have) using the [pak package](https://pak.r-lib.org/index.html).

```r
pkg_list <- c("bookdown", "devtools", "dichromat", "DT", "fs", "gapminder",
              "gender", "geonames", "git2r", "glue", "gridExtra",  "htmltools",
              "httr", "knitr", "RColorBrewer", "rebird", "rmarkdown", "rplos", 
              "rvest", "testthat", "tidyverse", "usethis", "viridis", "xfun", 
              "xml2", "ropensci/genderdata", "rstudio/gt")

# install.packages("pak")
pak::pkg_install(pkg_list)
```

This is nice because it can install from CRAN and, in the case of packages like `rstudio/gt`, also from GitHub.

<!--TODO: Change pkg_list to not be static, maybe use renv::dependencies(path = "DESCRIPTION")?-->

Note: the package list above is currently static, so consider that it may not be up to date.

## OMDb API key

One file, 37_diy-web-data.Rmd, accesses the Open Movie Database API, which requires a key. The site will render without this, without rendering this file. Set up an OMDb key to render this file.

1. Request an API key [here](https://www.omdbapi.com/apikey.aspx).
1. Check your email and follow the instructions to activate your key
1. Add the API key to your `.Renviron` file. First, open your .`Renviron` file with the usethis package:
  
    ```r
    library(usethis)
    edit_r_environ()
    ```
    
    Next, add `OMDB_API_KEY=<your-key>` on a new line, replacing `<your-key>` with your OMDb key. (Make sure to have your `.Renviron` file end on a new line!)
