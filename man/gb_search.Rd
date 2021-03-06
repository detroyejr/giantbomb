% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gb_search.R
\name{gb_search}
\alias{gb_search}
\title{GiantBomb Search}
\usage{
gb_search(search = NULL, n = 10, field_list = NULL, limit = 10,
  page = 1, resources = NULL, user_agent = NULL, delay = 30,
  api_key = gb_key())
}
\arguments{
\item{search}{a keyword or term to search.}

\item{n}{total number of results returned. Defaults to 10.}

\item{field_list}{columns to return.}

\item{limit}{total results per page. Defaults to 10.}

\item{page}{starting page number.}

\item{resources}{a list of resources to filter results. Accepts options:
game, franchise, character, concept, object, location, person, company,
video. Multiple options are allowed.}

\item{user_agent}{allows you to customize the user agent for your requests.
See the Details section for more information.}

\item{delay}{the wait time between each query.}

\item{api_key}{a GiantBomb api key. The default searches for GB_KEY in your
environment variables.}
}
\description{
Retrieve search results from the GiantBomb API.
}
\details{
An api key can be retrieved for the GiantBomb API after signing up
at \url{https://giantbomb.com/api}.

GiantBomb limits the query rate to 200 requests per resource per hour.
Additionally, you may experience issues if too many queries are made every
second. Each function attempts to mitigate problems by using a delay after
each query (default is 30 seconds). You can set \code{delay} to 0 if you want to
get the information faster, but GiantBomb may begin to block your requests
if you do this too often.

You may also want to use the \code{user_agent} parameter to customize how your
queries are being received. Doing so can minimize the possibility of
getting a captcha challenges.

Each query returns a maximum of 10 results per request. In order to get
100 results with a \code{limit} of 10, it would take 10 api requests.
}
\examples{
\dontrun{
# Get 10 companies.
res <- gb_search(search = "bioshock", resources = c("company", "game"))
res <- gb_search(search = "2k", resources = c("company"))
}

}
