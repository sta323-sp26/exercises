library(tidyverse)
library(nycflights13)
library(palmerpenguins)

## Example 1


# How many flights to Los Angeles (LAX) did each of the legacy 
# carriers (AA, UA, DL or US) have in May from JFK, and what 
# was their average duration?

flights |>
  filter(dest == "LAX") |>
  filter(carrier %in% c("AA","UA","DL","US")) |>
  filter(month == 5) |>
  group_by(carrier) |>
  summarize(
    avg_dur = mean(air_time, na.rm=TRUE)
  )
  
# Which plane (check the tail numbers) flew out of each 
# New York airport the most?

flights |>
  filter(!is.na(tailnum)) |>
  group_by(origin, tailnum) |>
  summarize(
    n = n(),
    .groups = "drop_last"
  ) |>
  arrange(desc(n)) |>
  filter(n == max(n))

flights |>
  filter(!is.na(tailnum)) |>
  count(origin, tailnum) |>
  group_by(origin) |>
  slice_max(order_by = n, n = 3)


# Which 5 days should you consider flying on if you want to 
# have the lowest possible average departure delay?

flights |>
  group_by(month, day) |>
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm=TRUE),
    .groups = "drop"
  ) |>
  slice_min(avg_dep_delay, n=5)
  
flights |>
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm=TRUE),
    .by = c(month, day)
  ) |>
  slice_min(avg_dep_delay, n=5)
  
# Which flight has the largest arrival delay as a percentage 
# of its scheduled air time?

flights |>
  mutate(
    arr_delay_pct = arr_delay / air_time
  ) |>
  slice_max(arr_delay_pct, n=1) |>
  select(
    year:day, origin, dest, tailnum, arr_delay, air_time, arr_delay_pct
  )


## Exercise 1

palmerpenguins::penguins |>
  count(island, species) |>
  pivot_wider(
    names_from = species,
    values_from = n,
    values_fill = 0
  )

## Example 2


grades = tibble::tribble(
  ~name,   ~hw_1, ~hw_2, ~hw_3, ~hw_4, ~proj_1, ~proj_2,
  "Alice",    19,    19,    18,    20,      89,      95,
  "Bob",      18,    20,    18,    16,      77,      88,
  "Carol",    18,    20,    18,    17,      96,      99,
  "Dave",     19,    19,    18,    19,      86,      82
)

final_grades = grades |>
  tidyr::pivot_longer(
    cols = hw_1:proj_2,
    names_to = c("type", "id"),
    names_sep = "_",
    values_to = "score"
  ) |>
  summarize(
    total = sum(score),
    .by = c(name, type)
  ) |>
  tidyr::pivot_wider(
    names_from = type,
    values_from = total
  ) |>
  mutate(
    score = 0.5*(hw/80) + 0.5*(proj/200)
  )

final_grades
