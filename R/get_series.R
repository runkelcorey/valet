#' Get series observations
#'
#' \code{get_series} returns observations from one or more Bank of Canada
#' series, subject to some date filtering.
#'
#' @param name A \code{character} of at least length 1 indicating the series to
#'   retrieve.
#' @param ... Additional query parameters. Possible values are \code{start_date}
#'   and/or \code{end_date} (both character), or one of \code{recent},
#'   \code{recent_weeks}, \code{recent_months}, or \code{recent_years} (all
#'   numeric).
#'
#' @return A \code{tibble} of size \eqn{length(name) + 1}.
#'
#' @examples
#' get_series("FXCADAUD")
#'
#' \dontrun{
#' #this is a group
#' get_series("BAPF")
#' }
#'
#' @importFrom purrr map_dfc map_chr
#' @importFrom dplyr mutate select
#' @importFrom readr type_convert
#'
#' @export
get_series <- function(name = NULL, ...) {

  results <- valet(name = paste(name, sep = "", collapse = ","), F, ...)[["content"]]

  df <- results[["observations"]][-1] %>%
    map_dfc(~ .x[["v"]]) %>%
    mutate(date = results[["observations"]][["d"]]) %>%
    type_convert() %>%
    suppressMessages() %>%
    select(date, names(results[["seriesDetail"]]))

  for (x in names(df)) {
    attr(df[[x]], "label") <- results[["seriesDetail"]][[x]][["label"]]
  }

  df
}
