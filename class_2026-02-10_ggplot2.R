library(tidyverse)
library(palmerpenguins)

## Exercise 1

penguins |>
  filter(!is.na(sex)) |>
  #mutate(
  #  sex = factor(sex, levels = c("male", "female"))
  #) |>
  ggplot(
    aes(x = body_mass_g, fill = species)
  ) +
  geom_density(alpha=0.5, color=NA) +
  facet_wrap(~sex, ncol=1) +
  labs(
    y = "", fill = "Species", x = "Body mass (g)"
  )


## Exercise 2

penguins |>
  ggplot(
    aes(x = flipper_length_mm, y = bill_length_mm, color = species)
  ) +
  geom_point(
    aes(shape = species), size=3, alpha=0.5,
    na.rm = TRUE
  ) +
  theme_minimal() +
  geom_smooth(method="lm", formula=y~x, se=FALSE, na.rm=TRUE) +
  scale_color_manual(values = c("darkorange", "purple", "cyan4"))
