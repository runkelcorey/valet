#' Retrieve observations from series
#'
#' @param name A character of length 1.
#' @return A \code{tibble}.
#'
#' @importFrom purrr map_dfc map_chr
#' @importFrom dplyr mutate select
#' @importFrom labelled set_variable_labels
#' @importFrom readr type_convert
#'
#' @export
get_group <- function(name = NULL) {

  df <- valet(name = name, T)[["content"]]

  df[["observations"]][-1] %>%
    map_dfc(~ .x[["v"]]) %>%
    type_convert() %>%
    suppressMessages() %>%
    select(names(df[["seriesDetail"]])) %>%
    labelled::set_variable_labels(.labels = map_chr(df[["seriesDetail"]], ~ .x[["label"]])) %>%
    rename_with(.fn = ~ tolower(sub(paste0(toupper(name), "_"), "", .x, fixed = T)))

}
