# Creating the `renv` lockfile

This is the code that GL ran in the Console to create the `renv` lockfile for the STAT 545 bookdown project:

1. `renv::init()` -- creates initial lockfile, adds three files: `renv/`, `renv.lock`, and `.Rprofile`.
1. Use `renv::modify()` to manually add the `servr` and `miniUI` packages to the lockfile since they will be needed for `bookdown::serve_book()`. These are not caught during step 1 since the default behavior of `renv::init()` / `renv::snapshot()` is to *not* capture dev dependencies. I chose to stick with this default to avoid overfilling the lockfile with unnecessary packages. 
1. `renv::hydrate(packages = c("servr", "miniUI"))` -- adds `servr` and `miniUI` to the `renv` package cache in the `renv/` folder. 
1. `renv::deactivate()` -- removes `.Rprofile`; "turns off" `renv` and the private, project-specific library.


# Netlify Redirects

When the bookdown reboot of STAT545 takes over the `https://stat545.com` domain, what was previously `https://stat545.com` will continue to exist indefinitely at `https://STAT545-UBC.github.io/STAT545-UBC.github.io`. All content on the previous `https://stat545.com` will be redirected based on the set of rules listed below, where "previous" refers to the old `https://stat545.com`, "bookdown" refers to the new `http://stat545.com`, "gh pages site" refers to `https://STAT545-UBC.github.io/STAT545-UBC.github.io`, and "happygitwithr" refers to `https://happygitwithr.com`. 

Redirect rules:

* Any previous `.html` that...
  + ...maps to a bookdown chapter --> redirects to the bookdown chapter.
  + ...maps to a happygitwithr page --> redirects to the happygitwithr page
  + ...does not map to bookdown or happygitwithr --> redirects to gh pages site
* Any previous static image files (`.png`), data files (`.csv`, `.txt`, `.tsv`), and `.pdf` --> redirects to the gh pages site
* Everything else (`.md`, `.R`, `.Rmd`, etc.) --> redirects to 404 (done automatically by Netlify).

The redirects will be done by Netlify using the `_redirects` file (see Netlify documentation [here](https://www.netlify.com/docs/redirects/#custom-404)). Four scripts in `admin/` are used to create these redirects:

* `admin/01_get-prev-stat545-urls.R`
    + Creates `admin/prev_stat545_urls.csv`
    + Gets all url paths for the previous `https://stat545.com` that we will redirect, i.e. those ending with `.html`, `.csv`, `.txt`, `.tsv`, `.png`, or `.pdf` 
* `admin/01_make-bookdown-mappings.R` 
    + Creates `admin/prev_stat545_to_bookdown.csv`
    + Gets the url path for bookdown chapters and maps them to the old url path on the previous `https://stat545.com`
* `admin/01_make_happygit_mappings.R`
    + Create `admin/prev_stat545_to_happygit.csv`
    + Maps the pages covering git on the previous `https://stat545.com` to the corresponding chapters on `https://happygitwithr.com`.
* `admin/02_make-redirects-mappings.R`
    + Creates `admin/redirects_mappings.csv` and `_redirects`
    + Combines `admin/prev_stat545_urls.csv`, `admin/prev_stat545_to_bookdown.csv`, and `admin/prev_stat545_to_happygit.csv` to create the final redirect mappings using the set of rules listed above that will be passed onto Netlify. 

## Notes & resources that were helpful

* Netlify docs on redirects [here](https://www.netlify.com/docs/redirects/#basic-redirects)
* Yihui's blogpost on redirects on netlify: https://yihui.name/en/2017/11/301-redirect/
* Yihui's `_redirects` file for his website [here](https://github.com/yihui/yihui.name/blob/c997fd7adbf4dd4fd09a52111c79307de9fee582/static/_redirects)
* Netlify only supports placeholders and path wildcards, so can't do anything like "*.html" :( -- see [this thread](https://community.netlify.com/t/410-status-code-issue-with-redirects/698/5).
* Specified HTTP status code 301 for redirects from old stat545 content  to the stat545 github.io placeholder (i.e. pages that were *not* moved over to the bookdown site). 
* Don't have to explicitly tell Netlify to redirect missing pages to a 404. Tested in a practice bookdown and if you add a 404.html file to the dir that Netlify publishes, Netlify will automatically recognize the 404.html and redirect any pages that don't exist there. 
  
# Deprecated STAT 545 Content

`admin/make-deprecated-csv.R` creates a tibble with info for the deprecated STAT 545 content listed on the previous `https://stat545.com/topics.html` under "Deprecated material that I no longer use. But last I checked, it’s not actually *wrong*" (-JB). This script creates `admin/deprecated_stat545_urls.csv`, which contains the titles, locations (relative url paths), and year last updated for these pages. This csv is used in the Deprecated section of the Appendix to create a table using the `gt` package.
