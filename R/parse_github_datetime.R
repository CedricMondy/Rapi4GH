#' Parse date strings from GitHub API in proper date-time
#'
#' @param date_string String description of the date
#'
#' @return date-time object
#' @export
#'
#' @importFrom lubridate parse_date_time
parse_github_datetime <- function(date_string) {
   lubridate::parse_date_time(
      x = date_string,
      orders = "Ymd HMS",
      tz = "UTC"
    )
}
