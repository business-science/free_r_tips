# R TIPS ----
# TIP 036 | ggside: side-plots for ggplot ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

# devtools::install_github("jtlandis/ggside")

library(ggside)
library(tidyverse)
library(tidyquant)

# DATA ----
mpg


# 1.0 GGSIDE ----

# 1.1 Side-Density ----

mpg %>%
    ggplot(aes(hwy, cty, color = class)) +
    geom_point(size = 2, alpha = 0.3) +
    geom_smooth(aes(color = NULL), se=TRUE) +
    geom_xsidedensity(
        aes(
            y    = after_stat(density),
            fill = class
        ),
        alpha    = 0.5,
        size     = 1
        ,
        position = "stack"
    ) +
    geom_ysidedensity(
        aes(
            x    = after_stat(density),
            fill = class
        ),
        alpha    = 0.5,
        size     = 1
        ,
        position = "stack"
    ) +
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq() +
    labs(title = "Fuel Economy by Vehicle Type" ,
         subtitle = "ggside density",
         x = "Highway MPG", y = "City MPG") +
    theme(
        ggside.panel.scale.x = 0.4,
        ggside.panel.scale.y = 0.4
    )


# 1.2 Side Boxplot w/ Facets ----

mpg %>%
    ggplot(aes(x = cty, y = hwy, color = class)) +
    geom_point() +
    geom_smooth(aes(color = NULL)) +
    geom_xsideboxplot(
        alpha    = 0.5,
        size     = 1
    ) +
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq() +
    facet_grid(cols = vars(cyl), scales = "free_x") +
    labs(
        title = "Fuel Economy by Engine Size (Cylinders)"
    ) +
    theme(
        ggside.panel.scale.x = 0.4
    )

# 2.0 LEARNING MORE -----

# R FOR BUSINESS ANALYSIS COURSE (DS4B 101-R)
# - Learn ggplot2 in Week 4 (Visualization)
#   https://university.business-science.io/p/ds4b-101-r-business-analysis-r

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/



