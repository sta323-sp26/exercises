library(tidyverse)
library(rvest)
library(httr2)

## get_lq.R examples

dir.create("data/lq", recursive = TRUE, showWarnings = FALSE)

url = "https://www.wyndhamhotels.com/laquinta/locations"

state.names

p = read_html(url)


hotels = p |>
  html_elements(".property a:nth-child(1)") |>
  html_attr("href") |>
  (\(x) paste0(url, x))()

## Dennys API example


## get_dennys.R examples