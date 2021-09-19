valet <- function(name = NULL, group = F) {
  url <- modify_url("https://www.bankofcanada.ca/", path = paste0("valet/observations/", ifelse(group, "group/", ""), name, "/json"))

  resp <- GET(url)

  parsed <- jsonlite::fromJSON(content(resp, "text"))

  if (http_error(resp)) {
    stop(
      sprintf(
        "Valet request failed [%s]",
        status_code(resp)
      ),
      call. = FALSE
    )
  }

  df <- parsed[["observations"]][-1] %>% #remove observation id
    purrr::map_dfc(~ .x[["v"]]) %>% #bind lists into tibble/data frame
    readr::type_convert() %>% #convert dates to dates, numbers to numbers, etc.
    suppressMessages() %>% #remove diagnostic message associated with type_convert()
    dplyr::rename_with(.fn = ~ tolower(str_remove(.x, paste0(toupper(name), "_")))) %>% #make names easier to type
    labelled::set_variable_labels(.labels = purrr::map_chr(parsed[["seriesDetail"]], ~ .x[["label"]])) #add variable labels

  structure(
    list(
      content = df,
      path = name,
      response = resp[-which(names(resp) == "content")]
    ),
    class = "valet"
  )



}
