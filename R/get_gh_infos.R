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
#' @importFrom httr GET authenticate content
#' @importFrom dplyr `%>%`
get_gh_info <- function(owner, repo, endpoint, query = "", auth_user = NULL, auth_pswd = NULL) {
  url_api <- paste0("https://api.github.com/repos/", owner, "/", repo, "/", endpoint)

  if (any(is.null(auth_user), is.null(auth_pswd))){
    response <- httr::GET(url = url_api, query = query)
  } else {
    response <- httr::GET(
      url = url_api,
      httr::authenticate(user = auth_user, password = auth_pswd),
      query = query
      )
  }

  response %>%
    httr::content("parsed")
}
