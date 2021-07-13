# R TIPS ----
# TIP 042 | ggdist: Raincloud Plots ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://mailchi.mp/business-science/r-tips-newsletter

# CREDIT ----
#  Cedric Scherer
#  https://www.cedricscherer.com/2021/06/06/visualizing-distributions-with-raincloud-plots-with-ggplot2/

# LIBRARIES ----

library(ggdist)
library(tidyquant)
library(tidyverse)

# DATA -----

mpg

# RAINCLOUD PLOTS ----
# - Very powerful for visualizing modality of distributions

mpg %>%
    filter(cyl %in% c(4,6,8)) %>%
    ggplot(aes(x = factor(cyl), y = hwy, fill = factor(cyl))) +

    # add half-violin from {ggdist} package
    ggdist::stat_halfeye(
        ## custom bandwidth
        adjust = 0.5,
        ## move geom to the right
        justification = -.2,
        ## remove slab interval
        .width = 0,
        point_colour = NA
    ) +
    geom_boxplot(
        width = .12,
        ## remove outliers
        outlier.color = NA,
        alpha = 0.5
    ) +
    # Add dot plots from {ggdist} package
    ggdist::stat_dots(
        ## orientation to the left
        side = "left",
        ## move geom to the left
        justification = 1.1,
        ## adjust grouping (binning) of observations
        binwidth = .25
    ) +
    # Adjust theme
    scale_fill_tq() +
    theme_tq() +
    labs(
        title = "Raincloud Plot",
        subtitle = "Showing the Bi-Modal Distribution of 6 Cylinder Vehicles",
        x = "Engine Size (No. of Cylinders)",
        y = "Highway Fuel Economy (MPG)",
        fill = "Cylinders"
    ) +
    coord_flip()

# LEARNING MORE ----

# R FOR BUSINESS ANALYSIS COURSE (DS4B 101-R)
# - Learn visualization {ggplot2} in Week 4 (4+ hours just on ggplot)
#   https://university.business-science.io/p/ds4b-101-r-business-analysis-r

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/

