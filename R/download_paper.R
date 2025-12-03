#' Downloads a Paper
#'
#' Unofficial API to [sci-hub.se](sci-hub.se).
#'
#' @param query *character*, DOI or URL of the paper you want to download.
#' @param path *character*, optional path of the `.pdf` file (full, with a
#'   filename), defaults to  temporary file.
#' @param open *logical*, whether to open the result (defaults to `TRUE`).
#' @param base_url *character*, base URL of the Sci-Hub instance to use.
#' @param citation_style *character*, citation style to use. One of `"apa"`,
#'   `"mla"`, `"gost"`, `"acs"`, `"acm"`, `"ieee"`, `"aip"`, `"ama"`, `"aps"`,
#'   `"cse"`, `"cep"`, `"gsa"`, or `"chicago"`. Defaults to `"apa"`.
#'
#' @return Called for its side effects, invisibly returns `NULL`.
#'
#' @export
#'
#' @importFrom xml2 xml_find_all xml_attr
#' @importFrom httr2 url_modify request req_url_path_append req_perform
#'   resp_body_html resp_body_json
#' @importFrom usethis ui_info ui_code_block
#' @importFrom rlang arg_match
#'
download_paper <- function(
  query,
  path = tempfile(fileext = ".pdf"),
  open = TRUE,
  base_url = "https://sci-hub.se/",
  citation_style = c(
    "apa",
    "mla",
    "gost",
    "acs",
    "acm",
    "ieee",
    "aip",
    "ama",
    "aps",
    "cse",
    "cep",
    "gsa",
    "chicago"
  )
) {
  citation_style <- arg_match(citation_style)

  req_pdf <- request(base_url) |> req_url_path_append(query)

  resp_pdf <- req_pdf |> req_perform()

  pdf_html <- resp_pdf |> resp_body_html()

  pdf_url_path <- pdf_html |>
    xml_find_all("//div[@class='download']//a") |>
    xml_attr("href")

  pdf_link <- url_modify(base_url, path = pdf_url_path)

  req_citation <- request(base_url) |>
    req_url_path_append("recite/") |>
    req_url_path_append(citation_style) |>
    req_url_path_append(query)

  resp_citation <- req_citation |> req_perform()

  citation_json <- resp_citation |> resp_body_json()
  citation_text <- citation_json$citation
  citation_style_from_resp <- citation_json$style

  ui_info("{citation_style_from_resp}-style citation:")
  ui_code_block(citation_text)

  if (open) system2("open", pdf_link)
}
