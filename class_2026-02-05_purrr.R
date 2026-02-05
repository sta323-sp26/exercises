library(tidyverse)

# Example 1

draw_points = function(n) {
  list(
    x = runif(n, -1, 1),
    y = runif(n, -1, 1)
  )
}

in_unit_circle = function(d) {
  sqrt(d$x^2 + d$y^2) <= 1
}

n = 1e5
draw_points(n) |>
  in_unit_circle() |>
  sum() |>
  (\(x) 4*x / n)()

tibble(
  n = 10^(1:6)
) |>
  mutate(
    draws = map(n, draw_points),
    n_in_ucirc = map_int(draws, ~sum(in_unit_circle(.x))),
    pi_approx = n_in_ucirc * 4 / n,
    pi_error = abs(pi_approx - pi)
  )
