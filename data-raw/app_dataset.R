## code to prepare `app_dataset` dataset goes here



# library -----------------------------------------------------------------

library(here)
library(dplyr)
library(readr)



# read and prep data ---------------------------------------------------------------

# India's national level gdp and gdppc data
read_csv("data-raw/1_data_gdp_and_percapita_gdp.csv") -> data_gdp
# countries of interest with their national level gdppc and gdp data

read_csv("data-raw/13_data_comparitive_countries.csv") %>%
  janitor::clean_names()-> data_cc



# State gdp data for india

read.csv(here("data-raw/9_1_data_epw_series_sdp_net.csv")) -> india_states_gdp

tidyr::pivot_longer(data = india_states_gdp,
                    cols = c(-1),
                    names_to = "states" ,
                    values_to = "gdp")%>%
  filter(year != "2021-2022") %>%
  mutate(
    year = stringr::str_extract(year, "....")|> as.numeric(),
    states = stringr::str_replace_all(states,"\\."," ")
  )-> india_states_gdp

# Stae gdppc data for india

read_csv(here("data-raw/10_1_data_epw_series_per_capita_sdp_net.csv")) -> india_states_gdppc

tidyr::pivot_longer(data = india_states_gdppc,
                    cols = c(-1),
                    names_to = "states" ,
                    values_to = "gdppc") %>%
  filter(year != "2021-2022")%>%
  mutate(
    year = stringr::str_extract(year, "....")|> as.numeric(),
    states = stringr::str_replace_all(states,"\\."," ")
  )-> india_states_gdppc


# data prep for forward looking national level ----------------------------------------


data_gdp %>% janitor::clean_names() -> data_gdp # India national level data for gdp and gdp per capita

rbind(
  data_gdp,
  tibble(
    year = c(2021:2050),
    total_population = 1380004385,
    gdp_current_usd = NA,
    gdp_per_capita_current_usd = NA
  )
) -> data_gdp_future # India National level data with years till 2050 for future time series charts. Has GDP and GDP per capita



# data prep for states forward looking ------------------------------------

## read data of states pop projections

read_csv("data-raw/12_data_states_pop_projection_census.csv") -> pop_projections_states

pop_projections_states %>%
  rename(states = State, year = Year, pop_proj = `Projected population`) %>%
  select(year, states, pop_proj) %>%
  mutate(
    states = stringr::str_to_upper(states),
    pop_proj = pop_proj*1000
  ) %>%
  filter(year>2020) %>%
  filter(!(states %in% c("THE DADRA AND NAGAR HAVELI AND DAMAN AND DIU",
                         "LAKSHADWEEP"))) %>%
  mutate(
    states = stringr::str_replace(states,pattern = "LADAKH",replacement = "JAMMU AND KASHMIR")
  ) %>%
  group_by(states, year) %>%
  summarise(
    pop_proj = sum(pop_proj,na.rm = T)
  ) %>%
  ungroup() %>%
  mutate(
    gdp = NA_integer_,
    gdppc = NA_integer_
  ) %>%
  relocate(year,states,pop_proj,gdp,gdppc) -> pop_projections_states

## create a single df for states actual gdp and gdppc

india_states_gdp %>%
  mutate(
    uid = paste(year,states)
  ) %>%
  left_join(
    india_states_gdppc %>%
      mutate(
        uid = paste(year,states)
      ),
    by = "uid"
  ) %>%
  rename(year = year.x, states = states.x) %>%
  select(year, states, gdp, gdppc) %>%
  mutate(
    pop_proj = NA_integer_
  ) %>%
  relocate(year,states,pop_proj,gdp,gdppc) -> states_gdp_gdppc

## create a unified data frame

rbind(
  states_gdp_gdppc,
  pop_projections_states
) -> data_states_future


# write to sysdata --------------------------------------------------------


usethis::use_data(data_gdp,data_cc,
                  data_gdp_future,india_states_gdp,
                  india_states_gdppc,
                  data_states_future,
                  overwrite = T,internal = T)

