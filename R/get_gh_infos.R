#' Retrieve informations from a GH repo
#'
#' @param owner character. Name of the GH owner of the repo
#' @param repo character. Name of the GH repo
#' @param endpoint character. Endpoint (commits, forks, issues...) to for which
#'   information is required
#' @param query filters to narrow down the API call
#' @param auth_user character. GH user name used for API authentification
#' @param auth_pswd character. GH password or token used for API authentification
#'
#' @return a nested list (JSON format) with all informations about repo forks
#' @export
#'
#' @importFrom dplyr `%>%`
#' @importFrom httr GET authenticate http_status content headers
#' @importFrom stringr str_split str_detect str_remove_all
get_gh_info <- function(owner, repo, endpoint, query = NULL, auth_user = NULL, auth_pswd = NULL) {
  url_api <- paste0("https://api.github.com/repos/", owner, "/", repo, "/", endpoint, ifelse(is.null(query), "", paste0("?", query)))

  all_contents <- list()

  while(length(url_api) > 0) {

    if(!is.null(auth_user) & !is.null(auth_pswd)) {
      response <- httr::GET(
        url = url_api,
        httr::authenticate(user = auth_user, password = auth_pswd)
      )
    } else {
      response <- httr::GET(url = url_api)
      }

    if(httr::http_status(response)$category != "Success")
      break()

    all_contents <- c(
      all_contents,
      httr::content(response, "parsed")
        )

    if (!is.null(query) && stringr::str_detect(query, "&page="))
      break()

    url_api <- response %>%
        httr::headers() %>%
        `$`(link) %>%
        (function(x) {
          if (is.null(x)) {
            x
          } else {
            stringr::str_split(x, ",") %>%
              `[[`(1) %>%
              `[`(stringr::str_detect(., pattern = "next")) %>%
              stringr::str_remove_all(pattern = "<|>|; rel=\"next\"")
          }
        })


  }

  all_contents

}
