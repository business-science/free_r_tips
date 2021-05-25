# R TIPS ----
# TIP 038 | gghalves: Half Dot Plots and Half Boxplots ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

library(tidyverse)
library(tidyquant)
library(gghalves)

# DATA ----
mpg


# 1.0 BASIC JITTER PLOT ----
mpg %>%
    filter(cyl != 5) %>%
    mutate(cyl = factor(cyl)) %>%
    ggplot(aes(cyl, hwy)) +
    geom_jitter() +
    theme_tq()

# 2.0 BOXPLOT: Distribution ----
mpg %>%
    filter(cyl != 5) %>%
    mutate(cyl = factor(cyl)) %>%
    ggplot(aes(cyl, hwy)) +
    geom_boxplot(outlier.colour = "red") +
    theme_tq()

# 3.0 HALF-BOXPLOT / HALF-DOTPLOT ----
mpg %>%
    filter(cyl != 5) %>%
    mutate(cyl = factor(cyl)) %>%
    ggplot(aes(cyl, hwy, color = cyl)) +

    geom_half_boxplot(outlier.color = "red") +
    geom_half_dotplot(
        aes(fill = cyl),
        dotsize = 0.75,
        stackratio = 0.5,
        color = "black"
    ) +

    facet_grid(cols = vars(cyl), scales = "free_x") +
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq() +
    labs(
        title = "Highway Fuel Economy by Engine Size",
        subtitle = "Half-Boxplot + Half-Dotplot"
    )

# 4.0 INSPECT CYL 6 ----
mpg %>%
    filter(cyl == 6) %>%
    ggplot(aes(class, hwy, fill = class)) +
    geom_boxplot() +
    scale_fill_tq() +
    theme_tq() +
    labs(title = "6 Cylinder Vehicles: Pickup and SUV causing Bi-Modal Relationship")


# Bonus: With Half Plots
mpg %>%
    filter(cyl == 6) %>%
    ggplot(aes(class, hwy, fill = class)) +
    geom_half_boxplot(
        outlier.colour = "red"
    ) +
    geom_half_dotplot(
        aes(fill = class),
        dotsize = 0.75,
        stackratio = 0.5,
        color = "black"
    ) +
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq() +
    labs(title = "6 Cylinder Vehicles: Pickup and SUV causing Bi-Modal Relationship")

# LEARNING MORE -----

# R FOR BUSINESS ANALYSIS COURSE (DS4B 101-R)
# - Learn ggplot2 in Week 4 (Visualization)
#   https://university.business-science.io/p/ds4b-101-r-business-analysis-r

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/

