#' Title
#'
#' @param data
#' @param scales
#' @param county
#'
#' @return
#' @export
#'
#' @examples
#' library(dplyr)
#' #districts_116_flat |> rename(state = STATE_NAME, district = DISTRICT) |> compute_district_116() |> head()
compute_district_116 <- function(data, scales, state = NULL, district = NULL, state_exclude = NULL){

  reference_filtered <- districts_116_reference_full
  #
  if(!is.null(state)){

    state %>% tolower() -> state

    reference_filtered %>%
      dplyr::filter(.data$STATE_NAME %>%
                      tolower() %in%
                      state) ->
      reference_filtered

  }

  if(!is.null(state_exclude)){

    state_exclude %>% tolower() -> state_exclude

    reference_filtered %>%
      dplyr::filter(!(.data$STATE_NAME %>%
                      tolower() %in%
                      state_exclude)) ->
      reference_filtered

  }

  if(!is.null(district)){

    district %>% tolower() -> district

    reference_filtered %>%
      dplyr::filter(.data$DISTRICT %>%
                        tolower() %in%
                        district) ->
      reference_filtered

  }


  # to prevent overjoining
  reference_filtered %>%
    dplyr::select("STATE_NAME","DISTRICT",  "geometry", "xmin",
                  "xmax", "ymin", "ymax") ->
    reference_filtered


  data %>%
    dplyr::inner_join(reference_filtered,
                      by = c("state" = "STATE_NAME",
                                   "district" = "DISTRICT")) %>%
    dplyr::mutate(group = -1) %>%
    dplyr::select(-state, -district)

}


StatDistrict116 <- ggplot2::ggproto(`_class` = "StatDistrict116",
                                 `_inherit` = ggplot2::Stat,
                                 compute_panel = compute_district_116,
                                 default_aes = ggplot2::aes(geometry =
                                                              ggplot2::after_stat(geometry)))



#' Title
#'
#' @param mapping
#' @param data
#' @param position
#' @param na.rm
#' @param show.legend
#' @param inherit.aes
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#'
#' library(ggplot2)
#' library(dplyr)
#' districts_116_flat |>
#' mutate(id = 1:n()) |>
#' ggplot() +
#' aes(state = STATE_NAME, district = DISTRICT) +
#' geom_district_116(state = "New York") +
#' aes(fill = id)
geom_district_116 <- function(
  mapping = NULL,
  data = NULL,
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE, ...
) {

  c(ggplot2::layer_sf(
    stat = StatDistrict116,  # proto object from step 2
    geom = ggplot2::GeomSf,  # inherit other behavior
    data = data,
    mapping = mapping,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = rlang::list2(na.rm = na.rm, ...)),
    coord_sf(default = TRUE)
  )

}






