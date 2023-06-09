### Step 0 access sf data set with geometries

### code to prepare `DATASET` dataset goes here

#   tmp_file <- tempfile()
#   zp <- "data-raw/districts114.zip"
#   unzip(zipfile = zp, exdir = "data-raw/districts114")
#   fpath <- "data-raw/districts114/districtShapes/districts114.shp"
# districts_114 <- sf::st_read(fpath)


unzip(zipfile = "data-raw/cb_2018_us_cd116_20m.zip", exdir = "data-raw/districts116")
districts_116_raw <- sf::st_read("data-raw/districts116/cb_2018_us_cd116_20m.shp")


read.csv("https://gist.githubusercontent.com/dantonnoriega/bf1acd2290e15b91e6710b6fd3be0a53/raw/11d15233327c8080c9646c7e1f23052659db251d/us-state-ansi-fips.csv") %>%
  rename(STATE_FIPS = st) %>%
  rename(STATE_NAME = stname) %>%
  rename(STATE_ABB = stusps) ->
state_fips_table

###### completion of step two, apply helper functions to get reference geometry

library(tidyverse)
districts_116_raw %>%
  rename(DISTRICT = CD116FP) %>%
  mutate(DISTRICT = as.numeric(DISTRICT)) %>%
  mutate(STATE_FIPS = as.numeric(STATEFP)) %>%
  select(-STATEFP) %>%
  left_join(state_fips_table ) ->
districts_116

### Step 00 make that data available in the package if desired

# usethis::use_data(districts_114, overwrite = TRUE)
usethis::use_data(districts_116, overwrite = TRUE)


### Step 1 drop geometry and select columns of interest for demonstration purposes to make available
#
# districts_114 |>
#   sf::st_drop_geometry() ->
# districts_114_flat

districts_116 |>
  sf::st_drop_geometry() ->
  districts_116_flat

# usethis::use_data(districts_114_flat, overwrite = TRUE)
usethis::use_data(districts_116_flat, overwrite = TRUE)


##### Step 2 use functions below if possible to create a reference data frame
##### for use in the compute panel function in ggplot2

##### Helper function 2.a
bbox_to_df <- function(bbox = sf::st_bbox(nc)){

  data.frame(xmin = bbox[[1]],
             ymin = bbox[[2]],
             xmax = bbox[[3]],
             ymax = bbox[[4]])

}


####### helper function 2.b
add_row_bounding_box <- function(data = nc){

  for (i in 1:nrow(data)){

    if(i == 1){df <- data[i,] |> sf::st_bbox() |> bbox_to_df() }else{

      dplyr::bind_rows(df,
                       data[i,] |> sf::st_bbox() |> bbox_to_df()) ->
        df
    }

    df

  }

  dplyr::bind_cols(df, data)

}

###### helper function 2.c.
create_geometries_reference <- function(sfdata = nc,
                                        id_cols = c(NAME, FIPS),
                                        geometry = geometry){

  sfdata |>
    add_row_bounding_box() |>
    dplyr::select({{id_cols}}, xmin, ymin, xmax, ymax, geometry)

}


create_geometries_reference(sfdata = districts_116,
                            id_cols = c(STATE_FIPS, STATE_NAME, STATE_ABB, DISTRICT)) ->
  districts_116_reference_full

usethis::use_data(districts_116_reference_full, overwrite = TRUE)


# ###### completion of step two, apply helper functions to get reference geometry
# create_geometries_reference(sfdata = districts_114,
#                             id_cols = c(STATENAME, DISTRICT))->
#   districts_114_reference_full

# usethis::use_data(districts_114_reference_full, overwrite = TRUE)

