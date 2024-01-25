#' Format information on commits
#'
#' @param info_commits A nested list resulting from the call of get_gh_infos on the commits endpoint
#'
#' @return a data frame with 5 columns: `author`, `url`, `date`, `message` and `sha` (i.e. the hash) of the commits
#'
#' @export
#'
#' @importFrom dplyr tibble
#' @importFrom purrr map list_rbind
format_commits <- function(info_commits) {
  info_commits %>%
    purrr::map(
      function(commit) {
        dplyr::tibble(
          author = commit$author$login,
          url = commit$html_url,
          date = parse_github_datetime(commit$commit$author$date),
          message = commit$commit$message,
          sha = commit$sha
        )
      }
    ) %>%
    purrr::list_rbind()
}
