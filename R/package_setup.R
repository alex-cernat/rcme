# to do
#
# document data: https://r-pkgs.org/data.html
# set up with correct name
# update readme
# document all functions
# make examples
# vignette
# put package names in front of all functions






# set-up

.libPaths("D:/r/packages/")
#install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
library(devtools)
library(tidyverse)
library(roxygen2)
library(knitr)

# ignore the meta file in building the package
usethis::use_build_ignore("./R/package_setup.R")
usethis::use_git_ignore("./R/package_setup.R")



# sets up git
use_git()
use_github()
use_readme_rmd()
build_readme()


# load data
load("C:/Users/msassac6/Dropbox (The University of Manchester)/Grants/Measurement error and crime - project/crime_me_package/crime_me_functions/data/clean_syn/sysdata.Rda")

usethis::use_data(crime_damage, crime_damage, overwrite = T)
usethis::use_data(crime_disorder, crime_disorder, overwrite = T)

# make licence
use_mit_license()

# make documentation from metadata in each function
document()

# loads packages
load_all()

# checks built
check()




# install package in our library
install()

# now we can load package
library("TestPackage.R")

# create unit test
use_testthat()
use_test("lm_me_ind.R")

library(testthat)
load_all()
test()

# use functions from another package
use_package("stringr")
use_package("purrr")
use_package("ggplot2")
use_package("ggrepel")
use_package("dplyr")

# sets up use of pipe
use_pipe()





# document again
document()

# check and install
check()
install()



# Test --------------------------------------------------------------------

library(tidyverse)

# test --------------------------------------------------------------------

test_out <- lm_me_out(
  "damage_police_rate ~ collective_eff + unemployment + white +
  median_age",
  data = crime_damage,
  key_predictor = "collective_eff",
  S = 0.5,
  R_sd = 0.1,
  D = 0.0,
  log_var = T)

test_out


test_ind <- lm_me_ind(
  formula = "disorder ~ violence_police_rate + white_British + unemployment + median_age",
  data = crime_disorder,
  key_predictor = "violence_police_rate",
  S = 0.5,
  R_sd = 0.1,
  D = 0,
  log_var = F)

test_ind


