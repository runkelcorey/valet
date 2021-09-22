get_lists <- function(type = c("series", "groups")) {
  url <- httr::modify_url("https://www.bankofcanada.ca/", path = paste0("valet/lists/", match.arg(type, c("series", "groups")), "/json"))
  
  resp <- httr::GET(url, httr::user_agent("https://github.com/runkelcorey/valet"))
  
  parsed <- jsonlite::fromJSON(httr::content(resp, "text"))
  
  if (http_error(resp)) {
    stop(
      sprintf(
        "Valet request failed [%s]",
        status_code(resp)
      ),
      call. = FALSE
    )
  }
  
  parsed$series %>%
    purrr::map_dfr(~ .x) %>% #bind lists into tibble
    dplyr::mutate(series = names(parsed$series)) #add series id
}
