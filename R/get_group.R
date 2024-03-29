#' Get series-group observations
#'
#' \code{get_group} returns observations from a Bank of Canada series group.
#'
#' @param name A \code{character} of length 1 indicating the series group to
#'   retrieve.
#' @param ... Additional query parameters. Possible values are \code{start_date}
#'   and/or \code{end_date} (both character), or one of \code{recent},
#'   \code{recent_weeks}, \code{recent_months}, or \code{recent_years} (all
#'   numeric).
#'
#' @return A \code{tibble}.
#'
#' @details Valet, the server-side API, does not always return observations
#'   filtered by \strong{...} arguments for series groups, even if it will accept
#'   the request.
#'
#' @examples
#' get_group("BAPF_TRANSACTION_DATA")
#' get_group("gbpp")
#'
#' \dontrun{
#' #this is a series
#' get_group("FXCADAUD")
#' }
#'
#' @importFrom purrr map_dfc map_chr
#' @importFrom dplyr mutate select rename_with
#' @importFrom readr type_convert
#'
#' @export
get_group <- function(name = NULL, ...) {

  df <- valet(name = name, T, ...)[["content"]]

  results <- df[["observations"]][-1] %>%
    map_dfc(~ .x[["v"]]) %>%
    select(names(df[["seriesDetail"]])) %>%
    type_convert() %>%
    suppressMessages()

  for (x in names(results)) {
    attr(results[[x]], "label") <- df[["seriesDetail"]][[x]][["label"]]
  }

  while (all(grepl(sub("_.*", "", names(results[1])), names(results)))) {
    results <- rename_with(results, .fn = ~ tolower(sub(paste0(sub("_.*", "", names(results[1])), "_"), "", .x, fixed = T)))
  }

  if (names(df[["observations"]][1]) == "d")
  {results <- mutate(results, date = as.Date.character(df[["observations"]][[1]], .before = 1))}
  else {results <- mutate(results, id = df[["observations"]][[1]], .before = 1)}

  results

}
