# BUSINESS SCIENCE R TIPS ----
# R-TIP 053 | ggdensity: high density regions ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://jamesotto852.github.io/ggdensity/

# LIBRARIES ----

library(tidyverse)
library(tidyquant)
library(ggdensity)

# DATA ----

mpg

# VISUALIZATION ----

# * Basic ggplot (pretty tough to pick out the groups, right?) ----
mpg %>%
    ggplot(aes(displ, hwy, fill = class)) +
    geom_point(shape = 21, size = 3) +
    scale_fill_tq() +
    theme_tq()

# * High Density Regions ----
g1 <- mpg %>%
    ggplot(aes(displ, hwy, fill = class)) +

    # New geom
    geom_hdr(probs = c(0.9, 0.5)) +

    geom_point(shape = 21, size = 3) +
    scale_fill_tq() +
    theme_tq() +
    labs(title = "High Density Regions")

g1 + facet_wrap(~ class, ncol = 2)

# * High Density Lines ----
g2 <- mpg %>%
    ggplot(aes(displ, hwy, fill = class)) +

    # New geom
    geom_hdr_lines(
        aes(color = after_stat(probs)),
        probs = c(0.9, 0.6),
        alpha = 1
    ) +

    geom_point(shape = 21, size = 2) +
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq() +
    labs(title = "High Density Lines") +
    expand_limits(y = c(10, 60), x = c(0, 8))

g2 + facet_wrap(~ class)

# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

