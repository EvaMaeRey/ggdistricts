### Step 0 access sf data set with geometries

### code to prepare `DATASET` dataset goes here

  tmp_file <- tempfile()
  zp <- "data-raw/districts114.zip"
  unzip(zipfile = zp, exdir = "data-raw/districts114")
  fpath <- "data-raw/districts114/districtShapes/districts114.shp"
districts_114 <- sf::st_read(fpath)

### Step 00 make that data available in the package if desired

usethis::use_data(districts_114, overwrite = TRUE)


### Step 1 drop geometry and select columns of interest for demonstration purposes to make available

districts_114 |>
  sf::st_drop_geometry() ->
districts_114_flat

usethis::use_data(districts_114_flat, overwrite = TRUE)


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

###### completion of step two, apply helper functions to get reference geometry
create_geometries_reference(sfdata = districts_114,
                            id_cols = c(STATENAME, DISTRICT))  ->
  districts_114_reference_full

usethis::use_data(districts_114_reference_full, overwrite = TRUE)
