#' @importFrom utils str

print.valet <- function(x, ...) {
  cat("Valet", x$series, "\n", sep = "")
  str(x$content)
  invisible(x)
}
