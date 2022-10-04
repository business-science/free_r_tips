# BUSINESS SCIENCE R TIPS ----
# R-TIP 055 | ggradar: radar plots in  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://github.com/ricardo-bion/ggradar

# LIBRARIES ----

# devtools::install_github("ricardo-bion/ggradar", dependencies = TRUE)

library(ggradar)
library(tidyverse)
library(tidyquant)
library(scales)
library(corrr)


# DATA ----

mpg

# FORMAT ----

vehicle_summary_tbl <- mpg %>%
    select(class, where(is_numeric), -year) %>%

    # Median Values By Vehicle Class
    group_by(class) %>%
    summarise(
        across(displ:hwy, .fns = median)
    ) %>%
    ungroup() %>%

    # Prep for ggradar (make sure to scale to 0-1)
    rename(group = class) %>%
    mutate_at(vars(-group), rescale)

vehicle_summary_tbl

# RADAR PLOTS ----

# * Single Radar ----
vehicle_summary_tbl %>% ggradar()

vehicle_summary_tbl %>%
    ggradar(
        group.colours    = palette_light() %>% unname(),
        group.point.size = 0,
        group.line.width = 1,
        plot.title       = "MPG Comparison By Vehicle Class",
        fill             = TRUE,
        fill.alpha       = 0.25
    )


# * Faceted Radar ----
vehicle_summary_tbl %>%
    ggradar(
        group.colours = palette_light() %>% unname(),
        fill          = TRUE,
        fill.alpha    = 0.25
    ) +

    # Facet
    facet_wrap(~ group, ncol = 3) +

    # Theme
    theme_void() +
    scale_color_tq() +
    theme(
        strip.text = element_text(
            size   = 12,
            colour = "white",
            margin = margin(t = 5, b = 5)
        ),
        strip.background = element_rect(fill = "#2C3E50"),
        legend.position = "none",
        plot.margin = margin(10, 10, 10, 10)
    ) +

    # Title
    labs(title = "MPG Comparison By Vehicle Class")


# BONUS: Which Vehicles Are Most Similar? ----

# * Get Vehicle Similarity ----
vehicle_similarity_tbl <- vehicle_summary_tbl %>%

    # Transpose
    pivot_longer(cols = -1) %>%
    pivot_wider(
        names_from  = group,
        values_from = value
    ) %>%

    # Correlate and Arrange
    corrr::correlate() %>%
    mutate(across(where(is.numeric), .fns = ~ replace_na(., 1))) %>%
    arrange(`2seater`)

vehicle_similarity_tbl

# * Reorder By Similarity ----
vehicle_summary_tbl %>%

    mutate(group = factor(group, levels = vehicle_similarity_tbl$term)) %>%

    ggradar(
        group.colours    = palette_light() %>% unname(),
        group.point.size = 0,
        group.line.width = 1,
        fill             = TRUE,
        fill.alpha       = 0.25,
        grid.label.size  = 4
    ) +
    facet_wrap(~ group, ncol = 3) +
    scale_color_tq() +
    labs(title = "Vehicle Classes Arranged By Similarity") +
    theme(
        legend.position  = "none",
        strip.background = element_rect(fill = "#2C3E50"),
        strip.text       = element_text(color = "white")
    )

# LEARNING MORE ----
# - Has your data science progress has stopped?

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


