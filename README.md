  [![Travis build status](https://travis-ci.org/rstudio-education/stat545.svg?branch=master)](https://travis-ci.org/rstudio-education/stat545) [![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![Netlify Status](https://api.netlify.com/api/v1/badges/82ff5a18-8a13-4f25-b688-230b04bc5664/deploy-status)](https://app.netlify.com/sites/stat545-book/deploys)

This bookdown book is a *work in progress*. We'll update this `README` and the repo status when ready! :rocket:


# Requirements to preview the bookdown locally 

## OMDb API key

1. Request an API key [here](https://www.omdbapi.com/apikey.aspx).
1. Check your email and follow the instructions to activate your key
1. Add the API key to your `.Renviron` file. First, open your .`Renviron` file with the `usethis` package:
  
    ```r
    library(usethis)
    edit_r_environ()
    ```
    
    Next, add `OMDB_API_KEY=<your-key>` on a new line, replacing `<your-key>` with your OMDb key. (Make sure to have your `.Renviron` file end on a new line!)
    
## Required packages


### Use `pak` to install any missing packages

Here's one way to install the needed packages (only the ones that you don't already have) using the [`pak` package](https://pak.r-lib.org/index.html).

<!--TODO: Change pkg_list to not be static, maybe use renv::dependencies(path = "DESCRIPTION")?-->

```r
pkg_list <- c("bookdown", "devtools", "dichromat", "DT", "fs", "gapminder",
              "gender", "geonames", "git2r", "glue", "gridExtra",  "htmltools",
              "httr", "knitr", "RColorBrewer", "rebird", "rmarkdown", "rplos", 
              "rvest", "testthat", "tidyverse", "usethis", "viridis", "xfun", 
              "xml2", "ropensci/genderdata", "rstudio/gt", "rstudio/renv@46f1123")
```


```r
# install.packages("pak")
pak::pkg_install(pkg_list)
```

### Use `renv` to recreate our project library

Another option is to use the [`renv` package](https://rstudio.github.io/renv/index.html) to replicate our exact project library. `renv` will create a private, project-specific library that is separate from your personal library of packages. This would be a good option if, for example, you have another project that relies on a specific version of a package and you don't want to mess with it by upgrading, downgrading, etc.

If you want to know more about what `renv` is doing behind the scenes see [Introduction to renv](https://rstudio.github.io/renv/articles/renv.html) and [Snapshot and Restore](https://environments.rstudio.com/snapshot.html#pre-requisite-steps).

Once you have a local copy of this project (either via fork/clone or downloading a zip file), follow these steps:

1. Install the development version of the `renv` package -- specifically, the same version we used to take a "snapshot" of our project library:
   
    ```r
    if (!requireNamespace("remotes"))
      install.packages("remotes")
  
    remotes::install_github("rstudio/renv@e0a0c13")
    ```
    
1. Run `renv::init(bare = TRUE)` in the Console.
    + This will create a private, project-specific library. The `bare = TRUE` argument tells `renv` that it should *not* try to add anything to this new library yet. If you take a took at the Packages tab in RStudio there will be two headers: "Packrat Library" and "System Library". The only package listed under "Packrat library" (i.e. the private, proejct-specific library) will be `renv`.
1. Run `renv::restore()` in the Console.
    + This will print out "The following package(s) will be installed" followed by a long list of packages. Respond yes. `renv` will install the packages by copying them over from the cache in the `renv/` folder.
1. Restart R (*Session* > *Restart R*)
    + If you take a look at the Packages tab, there should be a lot more packages listed under "Packrat Library" now.
1. You should now be able to preview the bookdown via either `bookdown::serve_book()` or *Addins* > *Preview Book*.
  
  
*Note: The `renv` package is still in the development stage so these instructions may change over time!*

  
<!-- 
GL: How I created the lockfile

1. renv::init() -- creates initial lockfile, adds three files: renv/, renv.lock, and .Rprofile
2. Use renv::modify() to manually add the servr and miniUI packages to the lockfile since they will be needed for bookdown::serve_book(). These are not caught during step 1 since the default behavior of renv::init() / renv::snapshot() is to not capture dev dependencies
3. renv::hydrate(packages = c("servr", "miniUI")) -- adds servr and miniUI to the renv package cache in the renv/ folder
4. renv::deactivate() -- removes .Rprofile; "turns off" renv and the private, project-specific library

-->
