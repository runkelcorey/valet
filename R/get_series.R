#' Retrieve observations from series
#'
#' @param name A \code{character} of at least length 1 indicating the series to retrieve.
#' @param ... Additional query parameters. Possible values are \code{start_date} and/or \code{end_date} (both character), or one of \code{recent}, \code{recent_weeks}, \code{recent_months}, or \code{recent_years} (all numeric).
#'
#' @return A \code{tibble} of size \eqn{n+1} where \eqn{n = \code{length(name)}}.
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
