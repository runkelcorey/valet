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
#' @importFrom purrr map_dfc map_chr
#' @importFrom dplyr mutate select rename_with
#' @importFrom labelled set_variable_labels
#' @importFrom readr type_convert
#'
#' @export
get_group <- function(name = NULL, ...) {

  df <- valet(name = name, T, ...)[["content"]]

  df[["observations"]][-1] %>%
    map_dfc(~ .x[["v"]]) %>%
    type_convert() %>%
    suppressMessages() %>%
    select(names(df[["seriesDetail"]])) %>%
    labelled::set_variable_labels(.labels = map_chr(df[["seriesDetail"]], ~ .x[["label"]])) %>%
    rename_with(.fn = ~ tolower(sub(paste0(toupper(name), "_"), "", .x, fixed = T)))

}
