## code to prepare `app_dataset` dataset goes here



# library -----------------------------------------------------------------

library(dplyr)
library(readr)



# read data ---------------------------------------------------------------

read_csv("data-raw/1_data_gdp_and_percapita_gdp.csv") -> data_gdp


# data prep ----------------------------------------


data_gdp %>% janitor::clean_names() -> data_gdp # India national level data for gdp and gdp per capita

rbind(
  data_gdp,
  tibble(
    year = c(2021:2050),
    total_population = 1380004385,
    gdp_current_usd = NA,
    gdp_per_capita_current_usd = NA
  )
) -> data_gdp_future # India National level data with years till 2050 for future time series charts. Has GDP and GDp per capita


# write to sysdata --------------------------------------------------------


usethis::use_data(data_gdp,overwrite = T,internal = T)
