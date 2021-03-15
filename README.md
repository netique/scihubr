
<!-- README.md is generated from README.Rmd. Please edit that file -->

# scihubr

<!-- badges: start -->
<!-- badges: end -->

`{scihubr}` is an unofficial API to [sci-hub.se](sci-hub.se), making it
easy to download the papers you need within `R`. The package also offers
you a citation.

## Installation

The package is only available from [GitHub](https://github.com/) with:

``` r
if (!require("remotes") install.packages("remotes")
remotes::install_github("netique/scihubr")
```

## Example

If you just want ot read a paper as quick as possible, type:

``` r
scihubr::download_paper("url_or_doi_of_your_favourite_paper")
```

Or, state the path and optional `open = FALSE` meaning you do not want
to open the result immediately.

``` r
scihubr::download_paper("url_or_doi_of_your_favourite_paper",
  path = "~/my_favourite_paper.pdf",
  open = FALSE
)
```
