#' GiantBomb Search
#'
#' Retrieve search results from the GiantBomb API.
#'
#' @md
#' @param search a keyword or term to search.
#' @param n total number of results returned. Defaults to 10.
#' @param field_list columns to return.
#' @param limit total results per page. Defaults to 10.
#' @param page starting page number.
#' @param resources a list of resources to filter results. Accepts options:
#'   game, franchise, character, concept, object, location, person, company,
#'   video. Multiple options are allowed.
#' @param user_agent allows you to customize the user agent for your requests.
#'   See the Details section for more information.
#' @param delay the wait time between each query.
#' @param api_key a GiantBomb api key. The default searches for GB_KEY in your
#'   environment variables.
#'
#' @examples
#' \dontrun{
#' # Get 10 companies.
#' res <- gb_search(search = "bioshock", resources = c("company", "game"))
#' res <- gb_search(search = "2k", resources = c("company"))
#' }
#'
#' @details An api key can be retrieved for the GiantBomb API after signing up
#'   at [https://giantbomb.com/api](https://giantbomb.com/api).
#'
#'   GiantBomb limits the query rate to 200 requests per resource per hour.
#'   Additionally, you may experience issues if too many queries are made every
#'   second. Each function attempts to mitigate problems by using a delay after
#'   each query (default is 30 seconds). You can set `delay` to 0 if you want to
#'   get the information faster, but GiantBomb may begin to block your requests
#'   if you do this too often.
#'
#'   You may also want to use the `user_agent` parameter to customize how your
#'   queries are being received. Doing so can minimize the possibility of
#'   getting a captcha challenges.
#'
#'   Each query returns a maximum of 10 results per request. In order to get
#'   100 results with a `limit` of 10, it would take 10 api requests.
#'
#' @export
gb_search <- function(search = NULL, n = 10, field_list = NULL, limit = 10,
                      page = 1, resources = NULL, user_agent = NULL, delay = 30,
                      api_key = gb_key()) {
  url <- paste0(base, "search/")

  resl <- list()
  on.exit({
    resd <- do.call(rbind2, resl)
    n <- if (nrow(resd) < n) nrow(resd) else n
    resd <- resd[1:n, ]


    resd[names(resd) %in% date_cols] <- lapply(
      X = resd[names(resd) %in% date_cols],
      FUN = as.POSIXct,
      format = "%Y-%m-%d %X"
    )
    return(resd)
  })

  limit <- if (limit > 10) 10 else limit
  offset <- (seq_len(ceiling(n / limit)) - 1) + page

  for (i in 1:length(offset)) {
    query = list(
      api_key = api_key,
      query = search,
      field_list = paste(field_list, collapse = ","),
      limit = limit,
      page = offset[i],
      resources = paste(resources, collapse = ","),
      format = "json"
    )

    if (is.null(user_agent)) {
      res <- httr::GET(url, query = query)
    } else {
      res <- httr::GET(url, query = query, httr::user_agent(user_agent))
    }

    httr::stop_for_status(res)

    resd <- jsonlite::fromJSON(httr::content(res, as = "text"), flatten = TRUE)

    if (resd[["error"]] != "OK") {
      stop(resd[["error"]])
    }

    resl[[i]] <- resd[["results"]]

    if ((offset[i] + limit) > resd[["number_of_total_results"]]) {
      break
    }

    if (length(offset) > 1) Sys.sleep(delay)
  }
}
