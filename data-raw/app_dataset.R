## code to prepare `app_dataset` dataset goes here



# library -----------------------------------------------------------------

library(here)
library(dplyr)
library(readr)



# read data ---------------------------------------------------------------

# India's national level gdp and gdppc data
read_csv("data-raw/1_data_gdp_and_percapita_gdp.csv") -> data_gdp
# 15 countries of interest with their national level gdppc data
read.csv("data-raw/7_data_countries_interest_compare_gdp_per_capita_forward.csv") -> data_gdppc_countries

# State gdp data for india

read.csv(here("data-raw/9_1_data_epw_series_sdp_net.csv")) -> india_states_gdp

janitor::clean_names(india_states_gdp) -> india_states_gdp

# Stae gdppc data for india

read.csv(here("data-raw/10_1_data_epw_series_per_capita_sdp_net.csv")) -> india_states_gdppc

janitor::clean_names(india_states_gdppc) -> india_states_gdppc


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


usethis::use_data(data_gdp,data_gdppc_countries,
                  data_gdp_future,india_states_gdp,
                  india_states_gdppc,
                  overwrite = T,internal = T)
