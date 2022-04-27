## code to prepare `app_dataset` dataset goes here



# library -----------------------------------------------------------------

library(dplyr)
library(readr)



# read data ---------------------------------------------------------------

read_csv("data-raw/1_data_gdp_and_percapita_gdp.csv") -> data_gdp


# check if column names are proper ----------------------------------------




data_gdp %>% janitor::clean_names() -> data_gdp

data_gdp %>% mutate(
  year_seq = c(0:60)
) -> data_gdp




usethis::use_data(data_gdp, overwrite = TRUE)
