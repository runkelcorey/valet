#' Retrieve observations from series
#'
#' @param name A character of length 1.
#' @param group A Boolean.
#'
#' @return A list.
#'
#' @details \emph{name} refers to the series or series group name identifiable on the Bank of Canada's website or via \code{get_list}.
#'
#' @import httr
#' @importFrom jsonlite fromJSON
#'
#' @export
get_details <- function(name = NULL, group = F) {

  url <- modify_url("https://www.bankofcanada.ca/", path = paste0("valet/", ifelse(group, "groups/", "series/"), name, "/json"))

  resp <- GET(url, user_agent("https://github.com/runkelcorey/valet"))

  fromJSON(content(resp, "text"))[[2]]

}
