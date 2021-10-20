#' Retrieve Valet response.
#'
#' @param name A character of at least length 1.
#' @param group Boolean.
#'
#' @return A \code{valet} object.
#'
#' @import httr
#'
#' @export
valet <- function(name = NULL, group = F, ...) {

  url <- modify_url("https://www.bankofcanada.ca/", path = paste0("valet/observations/", ifelse(group, "group/", ""), name, "/json"), query = list(...))

  resp <- GET(url, user_agent("https://github.com/runkelcorey/valet"))

  parsed <- jsonlite::fromJSON(content(resp, "text"))

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
