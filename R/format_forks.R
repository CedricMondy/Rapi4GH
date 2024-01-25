#' Retrieve minimal information from a repo forks in a data frame
#'
#' @param info_forks A nested list resulting from the the call of get_gh_infos
#'   on the forks endpoint
#'
#' @return a data frame with four columns: `name`, `owner`, `url` of the fork
#'   and the date the fork was created (`created_at`)
#' @export
#'
#' @importFrom dplyr tibble `%>%`
#' @importFrom lubridate as_date
#' @importFrom purrr map list_rbind
format_forks <- function(info_forks) {
  info_forks %>%
    purrr::map(
      function(fork) {
        dplyr::tibble(
          name = fork$full_name,
          owner = fork$owner$login,
          url = fork$html_url,
          created_at = parse_github_datetime(fork$created_at) %>%
            lubridate::as_date()
        )
      }
    ) %>%
    purrr::list_rbind()
}
