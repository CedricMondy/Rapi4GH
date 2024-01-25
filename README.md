# Rapi4GH

This package provides some practical functions to explore GitHub repository characteristics such as commits, issues, forks using the GitHub API.

## Installation

``` r
if (!require("pak")) install.packages("pak")
pak::pkg_install("CedricMondy/Rapi4GH")
```

## Examples

The function `get_gh_info` is the main function and is used as an interface to GitHub API, we specify:

-   the GitHub account (`owner`) and the `repo` for which we want information,

-   the endpoint (`"commits"`, `"issues"`, `"forks"`...) we are interested in,

-   an optional query to change the scope of the API call (e.g. `"sha=main"` to get only commits from the main branch)

-   optional GitHub credentials `auth_user` and `auth_pswd` to make identified calls to the API and therefore lowering the restrictions

The different `format_` functions (`format_commits`, `format_issues`, `format_forks`) are used to select some of the information from the JSON-like API results (nested lists) and return them as data frames.

``` r
Rapi4GH::get_gh_info(
  owner = "CedricMondy", repo = "Rapi4GH",
  endpoint = "commits"
) |> 
  Rapi4GH::format_commits()
```
