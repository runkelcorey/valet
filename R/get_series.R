#' Retrieve observations from series
#'
#' @param name A character of at least length 1.
#' @return A \code{tibble}.
#'
#' @importFrom purrr map_dfc map_chr
#' @importFrom dplyr mutate select
#' @importFrom labelled set_variable_labels
#' @importFrom readr type_convert
#'
#' @export
get_series <- function(name = NULL, ...) {

  df <- valet(name = paste(name, sep = "", collapse = ","), F, ...)[["content"]]

  df[["observations"]][-1] %>%
    map_dfc(~ .x[["v"]]) %>%
    mutate(date = df[["observations"]][["d"]]) %>%
    type_convert() %>%
    suppressMessages() %>%
    select(date, names(df[["seriesDetail"]])) %>%
    labelled::set_variable_labels(.labels = append("YYYY-MM-DD", map_chr(df[["seriesDetail"]], ~ .x[["label"]])))

}
