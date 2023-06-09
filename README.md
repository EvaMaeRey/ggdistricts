
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggdistricts

<!-- badges: start -->

<!-- badges: end -->

The goal of ggdistricts is to …

## Installation

You can install the development version of ggdistricts from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("EvaMaeRey/ggdistricts")
```

``` r
library(ggdistricts)
library(ggplot2)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
districts_116_flat |>
mutate(id = 1:n()) |>
ggplot() +
  aes(state = STATE_NAME, 
      district = DISTRICT) +
  geom_district_116(state = "New York") +
  aes(fill = DISTRICT)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r
library(ggdistricts)
library(ggplot2)
library(dplyr)
districts_116_flat |>
ggplot() +
  aes(state = STATE_NAME, 
      district = DISTRICT) +
  geom_district_116(state = "New York", linewidth = .02) +
  aes(fill = as.numeric(DISTRICT)) + 
  geom_district_116(state = "New York", 
                    district = 22, color = "red", linewidth = .05)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
districts_116_flat |>
ggplot() +
  aes(state = STATE_NAME, 
      district = DISTRICT) +
  geom_district_116(state = "New York", 
                    district = 22, 
                    color = "red", 
                    linewidth = 3)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

# lots of points…

``` r
library(sf)
#> Linking to GEOS 3.10.2, GDAL 3.4.2, PROJ 8.2.1; sf_use_s2() is TRUE
sum(rapply(st_geometry(districts_116), nrow)) # big
#> [1] 30166
sum(rapply(st_geometry(ggnc::nc), nrow)) # needlessly
#> [1] 2529
```
