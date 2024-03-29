#' Retrieve Valet response
#'
#' \code{valet} is the core back-end to get responses from the Bank of Canada
#' API.
#'
#' @param name A character of at least length 1 indicating the series or series
#'   group to retrieve.
#' @param group Boolean indicating whether the \code{name} is a series or a
#'   series group.
#' @param ... Query parameters from other methods.
#'
#' @return A \code{valet} object.
#'
#' @examples
#' valet(name = "GBPP", group = TRUE, recent_weeks = 2)
#'
#' @import httr
#' @importFrom jsonlite fromJSON
#'
#' @export
valet <- function(name = NULL, group = FALSE, ...) {

  url <- modify_url("https://www.bankofcanada.ca/", path = paste0("valet/observations/", ifelse(group, "group/", ""), name, "/json"), query = list(...))

  resp <- GET(url, user_agent("https://github.com/runkelcorey/valet"))

  parsed <- fromJSON(content(resp, "text"))

  if (http_error(resp)) {
    stop(
      sprintf(
        "Valet request failed [%s]\n%s\nSee %s",
        status_code(resp),
        parsed$message,
        parsed$docs
      ),
      call. = FALSE
    )
  }

  structure(
    list(
      content = parsed,
      path = name,
      response = resp[-which(names(resp) == "content")]
    ),
    class = "valet"
  )

}
