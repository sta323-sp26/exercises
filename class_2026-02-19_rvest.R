library(tidyverse)
library(rvest)

url = "https://rottentomatoes.com"

(session = polite::bow(url))


scrape_movie = function(url) { 
  
  page = session |>
    polite::nod(url) |>
    polite::scrape()
  
  list(
    mpaa_rating = page |>
      html_elements(
        "#hero-wrap rt-text:nth-child(7)"
      ) |> 
      html_text(),
    
    runtime = page |>
      html_elements(
        "media-hero > rt-text:nth-child(9)"
      ) |> 
      html_text()
  )
}




tibble(
  title = session |>
    polite::scrape() |>
    html_elements(
      ".dynamic-text-list__streaming-links+ ul .dynamic-text-list__item-title"
    ) |>
    html_text(),
  rating = session |>
    polite::scrape() |>
    html_elements(
      ".dynamic-text-list__streaming-links+ ul rt-text"
    ) |>
    html_text2() |>
    str_remove("%") |>
    as.numeric(),
  certified = session |>
    polite::scrape() |>
    html_elements(
      ".dynamic-text-list__streaming-links+ ul score-icon-critics"
    ) |>
    html_attr("certified") |>
    str_to_upper() |>
    as.logical(),
  sentiment = session |>
    polite::scrape() |>
    html_elements(
      ".dynamic-text-list__streaming-links+ ul score-icon-critics"
    ) |>
    html_attr("sentiment"),
  url = session |>
    polite::scrape() |>
    html_elements(
      ".dynamic-text-list__streaming-links+ ul .dynamic-text-list__tomatometer-group"
    ) |>
    html_attr("href") |>
    (\(x) paste0(url,x))()
) |>
  mutate(
    details = map(url, scrape_movie, .progress = TRUE)
  ) |>
  unnest_wider(details)

