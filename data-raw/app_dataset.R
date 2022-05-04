## code to prepare `app_dataset` dataset goes here



# library -----------------------------------------------------------------

library(dplyr)
library(readr)



# read data ---------------------------------------------------------------

read_csv("data-raw/1_data_gdp_and_percapita_gdp.csv") -> data_gdp


# create proper column columns ----------------------------------------


data_gdp %>% janitor::clean_names() -> data_gdp


# write to sysdata --------------------------------------------------------


usethis::use_data_raw(data_gdp, overwrite = TRUE)
