#' GiantBomb Platforms
#'
#' Retrieve a platform or platforms from the GiantBomb API.
#'
#' @md
#' @param id an object id.
#' @param n total number of results returned. Defaults to 100.
#' @param field_list columns to return.
#' @param limit total results per page. Defaults to 100.
#' @param offset starting result.
#' @param sort arrange results by column. Accepts a string with the format
#'   "column:direction".
#' @param filter reduce results by column attribute. Accepts a string with the
#'   format "column:value".
#' @param user_agent allows you to customize the user agent for your requests.
#'   See the Details section for more information.
#' @param delay the wait time between each query.
#' @param api_key a GiantBomb api key. The default searches for GB_KEY in your
#'   environment variables.
#'
#' @examples
#' \dontrun{
#' # Get 10 companies.
#' characters <- gb_platforms(n = 10)
#'
#' # Get a single company with an id.
#' characters <- gb_platforms(id = 360)
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
#'   Each query returns a maximum of 100 results per request. In order to get
#'   1000 results with a `limit` of 100, it would take 10 api requests.
#'
#' @export
gb_platforms <- function(id = NULL, n = 100, field_list = NULL, limit = 100,
                         offset = 0, sort = NULL, filter = NULL,
                         user_agent = NULL, delay = 30, api_key = gb_key()) {
  if (!is.null(id)) {
    stopifnot(length(id) == 1)
    url <- paste0(base, "platform/", id, "/")
  } else {
    url <- paste0(base, "platforms/")
  }

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

  limit <- if (limit > 100) 100 else limit
  offset <- set_offset(offset, n, limit)

  for (i in 1:length(offset)) {
    query = list(
      api_key = api_key,
      field_list = paste(field_list, collapse = ","),
      limit = limit,
      offset = offset[i],
      sort = sort,
      filter = paste(filter, collapse = ","),
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
