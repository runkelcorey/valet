#' Get series or series-group details
#'
#' \code{get_details} returns metadata from a Bank of Canada series or series
#' group.
#'
#' @param name A character of length 1 indicating the series or series group for
#'   which information should be retrieved.
#' @param group A Boolean indicating whether the \code{name} is a series or a
#'   series group.
#'
#' @return A list of series or group details.
#'
#' @examples
#' get_details("CES_C4E_LOSE_JOB_SK")
#' \dontrun{
#' get_details("BAPF_TRANSACTION_DATA")
#' }
#' get_details("BAPF_TRANSACTION_DATA", group = TRUE)
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
