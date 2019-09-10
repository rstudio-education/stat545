# Creates a csv redirecting the pages about git on the previous stat545.com
# to the corresponding happygitwithr.com chapter (their new home). Redirects
# were chosen by GL by looking through the file changes in the commit below
# and matching each html with the closet happygitwithr.com html:
# https://github.com/STAT545-UBC/STAT545-UBC.github.io/commit/fa6b6856c9680c45f33bea81bba95a88e5145bd7

library(dplyr)
library(readr)

hg_redirects <- tribble(
  ~stat545_path, ~happygit_path,
  "git00_index.html", "index.html",
  "git01_git-install.html", "install-intro.html",
  "git02_git-clients.html", "git-client.html",
  "git03_rstudio-meet-git.html", "rstudio-see-git.html",
  "git04_introduce-self-to-git.html", "hello-git.html",
  "git05_github-connection.html", "push-pull-github.html",
  "git06_credential-caching.html", "credential-caching.html",
  "git07_git-github-rstudio.html", "rstudio-git-github.html",
  "git09_shell.html", "shell.html",
  "git66_rstudio-git-github-hell.html", "troubleshooting.html")


write_csv(hg_redirects, "admin/prev_stat545_to_happygit.csv")