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
#' #districts_118_flat |> rename(state = STATE_NAME, district = DISTRICT) |> compute_district_118() |> head()
compute_district_118 <- function(data, scales, keep_state = NULL, keep_district = NULL, drop_state = NULL){

  reference_filtered <- districts_118_reference_full
  #
  if(!is.null(keep_state)){

    keep_state %>% tolower() -> keep_state

    reference_filtered %>%
      dplyr::filter(
        .data$STATE_NAME %>%
                      tolower() %in%
                      keep_state |
                    .data$STATE_ABB %>%
                      tolower() %in%
                      keep_state ) ->
      reference_filtered

  }

  if(!is.null(drop_state)){

    drop_state %>% tolower() -> drop_state

    reference_filtered %>%
      dplyr::filter(!(.data$STATE_NAME %>%
                      tolower() %in%
                        drop_state  |
                        .data$STATE_ABB %>%
                        tolower() %in%
                        drop_state )) ->
      reference_filtered

  }

  if(!is.null(keep_district)){

    keep_district %>% toupper() -> keep_district

    keep_district %>% stringr::str_pad(2, side = "left", pad = "0") -> keep_district

    reference_filtered %>%
      dplyr::filter(.data$DISTRICT %>%
                      toupper() %in%
                      keep_district) ->
      reference_filtered

  }


  # to prevent overjoining
  reference_filtered %>%
    dplyr::select("STATE_NAME", "DISTRICT", "STATE_ABB", "geometry", "xmin",
                  "xmax", "ymin", "ymax") %>%
    rename(state =  STATE_NAME) %>%
    rename(district = DISTRICT) %>%
    rename(state_abb = STATE_ABB) ->
    reference_filtered


  data %>%
    dplyr::mutate(district = district %>% stringr::str_pad(2, side = "left", pad = "0")) %>%
    dplyr::inner_join(reference_filtered#,
                      # by = c("state" = "STATE_NAME",
                      #              "district" = "DISTRICT")
                      ) %>%
    dplyr::mutate(group = -1) %>%
    dplyr::select(-state, -district)

}


StatDistrict118 <- ggplot2::ggproto(`_class` = "StatDistrict118",
                                 `_inherit` = ggplot2::Stat,
                                 compute_panel = compute_district_118,
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
#' districts_118_flat |>
#' mutate(id = 1:n()) |>
#' ggplot() +
#' aes(state = STATE_NAME, district = DISTRICT) +
#' geom_district_118(keep_state = "New York") +
#' aes(fill = id)
geom_district_118 <- function(
  mapping = NULL,
  data = NULL,
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE, ...
) {

  c(ggplot2::layer_sf(
    stat = StatDistrict118,  # proto object from step 2
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






