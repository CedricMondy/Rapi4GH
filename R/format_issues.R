#' Format information on issues
#'
#' @param info_issues A nested list resulting from the call of get_gh_infos on
#'   the issues endpoint
#'
#' @return a data frame with 9 columns: `author`, `url`, `title`, `body`, number of comments (`nb_comments`), actual `state` of the issues and dates at which the issues were `opened` and `closed`.
#' @export
#'
#' @importFrom dplyr tibble `%>%`
#' @importFrom purrr map list_rbind
format_issues <- function(info_issues) {
  info_issues %>%
    purrr::map(
      function(issue) {
        dplyr::tibble(
          author = issue$user$login,
          url = issue$html_url,
          type = ifelse(length(issue$labels) > 0, issue$labels[[1]]$name, NA),
          title = issue$title,
          body = issue$body,
          nb_comments = issue$comments,
          state = issue$state,
          opened = parse_github_datetime(issue$created_at),
          closed = as.POSIXct(ifelse(!is.null(issue$closed_at), parse_github_datetime(issue$closed_at), NA), tz = "UTC", origin = '1970-01-01 00:00.00 UTC'),
          is_pr = "pull_request" %in% names(issue)
        )
      }
    ) %>%
    purrr::list_rbind()
}
