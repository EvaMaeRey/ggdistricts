% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom_district116.R
\name{geom_district_116}
\alias{geom_district_116}
\title{Title}
\usage{
geom_district_116(
  mapping = NULL,
  data = NULL,
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  ...
)
}
\arguments{
\item{...}{}
}
\description{
Title
}
\examples{

library(ggplot2)
library(dplyr)
districts_116_flat |>
mutate(id = 1:n()) |>
ggplot() +
aes(state = STATE_NAME, district = DISTRICT) +
geom_district_116(keep_state = "New York") +
aes(fill = id)
}
