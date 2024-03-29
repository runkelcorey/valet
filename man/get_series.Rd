% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_series.R
\name{get_series}
\alias{get_series}
\title{Get series observations}
\usage{
get_series(name = NULL, ...)
}
\arguments{
\item{name}{A \code{character} of at least length 1 indicating the series to
retrieve.}

\item{...}{Additional query parameters. Possible values are \code{start_date}
and/or \code{end_date} (both character), or one of \code{recent},
\code{recent_weeks}, \code{recent_months}, or \code{recent_years} (all
numeric).}
}
\value{
A \code{tibble} of size \eqn{length(name) + 1}.
}
\description{
\code{get_series} returns observations from one or more Bank of Canada
series, subject to some date filtering.
}
\examples{
get_series("FXCADAUD")

\dontrun{
#this is a group
get_series("BAPF")
}

}
