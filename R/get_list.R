#' List possible series or groups.
#'
#' @param type Either \code{series} or \code{groups}.
#'
#' @return A \code{tibble}.
#'
#' @importFrom httr modify_url
#' @importFrom readr read_csv
#'
#' @export
get_list <- function(type = c("series", "groups")) {

  url <- modify_url("https://www.bankofcanada.ca/", path = paste0("valet/lists/", match.arg(type, c("series", "groups")), "/csv"))

  readr::read_csv(url, skip = 4, col_types = cols())

}
