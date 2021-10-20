#' Retrieve observations from series
#'
#' @param name A character of length 1 indicating the series or series group for which information should be retrieved.
#' @param group A Boolean indicating whether the \code{name} is a series or a series group.
#'
#' @return A list of series or group details.
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
