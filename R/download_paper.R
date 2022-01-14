#' Downloads a Paper
#'
#' Unofficial API to [sci-hub.se](sci-hub.se).
#'
#' @param query *character*, DOI or URL of the paper you want to download.
#' @param path *character*, optional path of the `.pdf` file (full, with a
#'   filename), defaults to  temporary file.
#' @param open *logical*, whether to open the result (defaults to `TRUE`).
#'
#' @return
#' @export
#'
#' @importFrom xml2 xml_find_first xml_attr read_html xml_text xml_find_all
#' @importFrom httr parse_url build_url
#' @importFrom readr read_file_raw
#' @importFrom usethis ui_info ui_code_block
#' @importFrom magrittr %>%
#' @importFrom stringr str_trim
#'
download_paper <- function(query,
                           path = tempfile(fileext = ".pdf"),
                           open = TRUE) {
  content <- read_html(paste0("https://sci-hub.se/", query))

  paper_url_raw <- content %>%
    xml_find_all("//*[@id='pdf']") %>%
    xml_attr("src") %>%
    parse_url()

  unescape_html <- function(str) {
    lapply(str, function(x) {
      xml_text(read_html(paste0("<x>", x, "</x>")))
    })
  }

  paper_citation <- content %>%
    xml_find_all("//div[@id='citation']//text()") %>%
    as.character() %>%
    str_trim() %>%
    unescape_html()

  paper_url_raw$scheme <- "https"
  paper_url_raw$fragment <- NULL

  paper_url <- paper_url_raw %>% build_url()

  read_file_raw(paper_url) %>% writeBin(path)

  ui_info("Cite as:")
  ui_code_block(paper_citation)

  if (open) system2("open", path)
}
