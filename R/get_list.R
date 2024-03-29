#' List possible series or groups.
#'
#' \code{get_list} returns metadata about all Bank of Canada series or series
#' groups.
#'
#' @param type Either \code{series} or \code{groups}.
#'
#' @return A \code{tibble} of series or group information.
#'
#' @importFrom httr modify_url
#' @importFrom readr read_csv cols
#'
#' @export
get_list <- function(type = c("series", "groups")) {

  url <- modify_url("https://www.bankofcanada.ca/", path = paste0("valet/lists/", match.arg(type, c("series", "groups")), "/csv"))

  readr::read_csv(url, skip = 4, col_types = cols())

}
