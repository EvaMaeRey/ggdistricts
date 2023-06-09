
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggdistricts \< 1.0 MB

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

head(districts_116_flat)
#>   DISTRICT      AFFGEOID GEOID LSAD CDSESSN      ALAND    AWATER STATE_FIPS
#> 1       10 5001600US3410  3410   C2     116  196397289  12474852         34
#> 2        5 5001600US4205  4205   C2     116  548506604  26310378         42
#> 3       12 5001600US0612  0612   C2     116  100885569 211661576          6
#> 4        3 5001600US1203  1203   C2     116 9232593580 722972427         12
#> 5       45 5001600US0645  0645   C2     116  856078764   5161857          6
#> 6        7 5001600US1207  1207   C2     116 1017471375 110917454         12
#>     STATE_NAME STATE_ABB
#> 1   New Jersey        NJ
#> 2 Pennsylvania        PA
#> 3   California        CA
#> 4      Florida        FL
#> 5   California        CA
#> 6      Florida        FL

districts_116_flat |>
mutate(id = 1:n()) |>
ggplot() +
  aes(state = STATE_NAME, 
      district = DISTRICT) +
  geom_district_116(state = "New York") +
  aes(fill = DISTRICT)
#> Warning in ggplot2::layer_sf(stat = StatDistrict116, geom = ggplot2::GeomSf, :
#> Ignoring unknown parameters: `state`
#> Joining with `by = join_by(state, district)`
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
  geom_district_116(keep_state = "New York", linewidth = .02) +
  aes(fill = as.numeric(DISTRICT)) + 
  geom_district_116(keep_state = "New York", 
                    district = 22, color = "red", linewidth = .05)
#> Joining with `by = join_by(state, district)`
#> Joining with `by = join_by(state, district)`
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
districts_116_flat |>
ggplot() +
  aes(state = STATE_NAME, 
      district = DISTRICT) +
  geom_district_116(keep_state = "NY", 
                    district = 22, 
                    color = "red", 
                    linewidth = 3)
#> Joining with `by = join_by(state, district)`
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

``` r
districts_116_flat |>
ggplot() +
  aes(state_abb = STATE_ABB, 
      district = DISTRICT) +
  geom_district_116(keep_state = "New York", 
                    color = "red", 
                    linewidth = 3)
#> Joining with `by = join_by(state_abb, district)`
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

# lots of points…

``` r
library(sf)
#> Linking to GEOS 3.10.2, GDAL 3.4.2, PROJ 8.2.1; sf_use_s2() is TRUE
sum(rapply(st_geometry(districts_116), nrow)) # big
#> [1] 30166
sum(rapply(st_geometry(ggnc::nc), nrow)) # needlessly
#> [1] 2529
```
