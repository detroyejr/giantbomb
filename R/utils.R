#' GiantBomb API KEY
#'
#' Helper function to retrieve an GiantBomb api key.
#'
#' @md
#' @export
gb_key <- function() {
  key <- Sys.getenv("GB_KEY")
  if (identical(key, "")) {
    stop("Please set environment variable 'GB_KEY' with your api key.")
  }
  key
}

#' rbind2
#'
#' Bind rows with mismatching column names.
#'
#' @md
#' @note `dplyr::bind_rows` is a much better alternative, but implementing
#' `rbind2` kept the number of package dependencies low.
#'
#' @param ... two or more valid objects that can be joined with `rbind`.
#'
rbind2 <- function(...) {
  dots <- as.list(substitute(as.list(...)))[-1L]
  res <- lapply(dots, eval, envir = parent.frame())
  cols <- unique(unlist(lapply(res, colnames)))
  res <- lapply(res, function(s) {
    d <- setdiff(cols, names(s))
    if (length(d) > 0 && NROW(s) > 0) {
      s[, d] <- NA
    }
    s
  })
  do.call(rbind, res)
}

#' Set Offset
#'
#' Given an n-size, limit, and offset parameter, return a vector of offsets.
#'
#' @param offset starting position for the results.
#' @param n total number of results.
#' @param limit number of results per query.
set_offset <- function(offset, n, limit) {
  if (n != 1) {
    x <- seq(from = offset, to = offset +  n, by = limit)
    x[!x == offset + n]
  } else {
    offset
  }
}
