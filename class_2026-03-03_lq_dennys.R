library(tidyverse)
library(rvest)
library(httr2)

## get_lq.R examples

dir.create("data/lq", recursive = TRUE, showWarnings = FALSE)

url = "https://www.wyndhamhotels.com"
#https://www2.stat.duke.edu/~cr173/data/lq/www.wyndhamhotels.com/laquinta/locations.html

state.name

p = read_html(file.path(url,"/laquinta/locations"))


hotels = p |>
  html_elements(".property a:nth-child(1)") |>
  html_attr("href") |>
  (\(x) paste0(url, x))()

out_file = dirname(hotels[1]) |>
  basename() |>
  (\(x) paste0(x, ".html"))()

message("Processing ", out_file, " ...")
download.file(
  url = hotels[1],
  destfile = file.path("data/lq/", out_file),
  quiet = TRUE
)

## parse_lq.R example

files = dir('data/lq', full.names = TRUE)

files[1] |> 
  read_file() |> # Handles edge case with a couple hotels and bad encoding
  read_html()

## Dennys API example

library(httr2)

request("https://www.dennys.com/restaurants/near") |>
  req_url_query(
    lat=35.779557,
    long=-78.638148,
    radius=1000,
    limit=1000,
    nomnom="calendars",
    nomnom_calendars_from=20260302,
    nomnom_calendars_to=20260310,
    nomnom_exclude_extref=999 
  ) |>
  req_perform() |>
  resp_body_json() |>
  View()


## get_dennys.R examples


url = "https://locations.dennys.com/"

p = read_html(url)

p |> 
  html_elements("#states-container a") |>
  html_attr("href")
