### Step 0 access sf data set with geometries

### code to prepare `DATASET` dataset goes here

#   tmp_file <- tempfile()
#   zp <- "data-raw/districts114.zip"
#   unzip(zipfile = zp, exdir = "data-raw/districts114")
#   fpath <- "data-raw/districts114/districtShapes/districts114.shp"
# districts_114 <- sf::st_read(fpath)

library(tidyverse)

unzip(zipfile = "data-raw/cb_2018_us_cd116_20m.zip", exdir = "data-raw/districts116")
unzip(zipfile = "data-raw/cb_2022_us_cd118_20m.zip", exdir = "data-raw/districts118")

districts_116_raw <- sf::st_read("data-raw/districts116/cb_2018_us_cd116_20m.shp")
districts_118_raw <- sf::st_read("data-raw/districts118/cb_2022_us_cd118_20m.shp")


str(districts_116_raw)

read.csv("https://gist.githubusercontent.com/dantonnoriega/bf1acd2290e15b91e6710b6fd3be0a53/raw/11d15233327c8080c9646c7e1f23052659db251d/us-state-ansi-fips.csv") %>%
  rename(STATE_FIPS = st) %>%
  rename(STATE_NAME = stname) %>%
  rename(STATE_ABB = stusps) %>%
  mutate(STATE_ABB = stringr::str_trim(STATE_ABB)) ->
state_fips_table

str(state_fips_table)

###### completion of step two, apply helper functions to get reference geometry

library(tidyverse)
districts_116_raw %>%
  rename(DISTRICT = CD116FP) %>%
  mutate(STATE_FIPS = as.numeric(STATEFP)) %>%
  select(-STATEFP) %>%
  left_join(state_fips_table ) ->
districts_116

districts_116 %>% filter(DISTRICT == "00" |
                           DISTRICT == "98" |
                           is.na(DISTRICT))

library(tidyverse)
districts_118_raw %>%
  rename(DISTRICT = CD118FP) %>%
  mutate(STATE_FIPS = as.numeric(STATEFP)) %>%
  select(-STATEFP) %>%
  left_join(state_fips_table ) ->
  districts_118

districts_118 %>% filter(DISTRICT == "00" |
                           DISTRICT == "98" |
                           is.na(DISTRICT))

### Step 00 make that data available in the package if desired

# usethis::use_data(districts_114, overwrite = TRUE)
usethis::use_data(districts_116, overwrite = TRUE)
usethis::use_data(districts_118, overwrite = TRUE)


### Step 1 drop geometry and select columns of interest for demonstration purposes to make available
#
# districts_114 |>
#   sf::st_drop_geometry() ->
# districts_114_flat

districts_116 |>
  sf::st_drop_geometry() ->
  districts_116_flat

districts_118 |>
  sf::st_drop_geometry() ->
  districts_118_flat

# usethis::use_data(districts_114_flat, overwrite = TRUE)
usethis::use_data(districts_116_flat, overwrite = TRUE)
usethis::use_data(districts_118_flat, overwrite = TRUE)


##### Step 2 use functions below if possible to create a reference data frame
##### for use in the compute panel function in ggplot2
library(sf)
ggnc:::create_geometries_reference(sfdata = districts_116,
                            id_cols = c(STATE_FIPS,
                                        STATE_NAME,
                                        STATE_ABB,
                                        DISTRICT)) ->
  districts_116_reference_full

ggnc:::create_geometries_reference(sfdata = districts_118,
                                  id_cols = c(STATE_FIPS,
                                              STATE_NAME,
                                              STATE_ABB,
                                              DISTRICT)) ->
  districts_118_reference_full


usethis::use_data(districts_116_reference_full, overwrite = TRUE)
usethis::use_data(districts_118_reference_full, overwrite = TRUE)


# ###### completion of step two, apply helper functions to get reference geometry
# create_geometries_reference(sfdata = districts_114,
#                             id_cols = c(STATENAME, DISTRICT))->
#   districts_114_reference_full

# usethis::use_data(districts_114_reference_full, overwrite = TRUE)

