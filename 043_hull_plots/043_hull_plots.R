# R TIPS ----
# TIP 043 | ggforce: hull plots ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://mailchi.mp/business-science/r-tips-newsletter


# LIBRARIES ----

library(ggforce)
library(tidyquant)
library(tidyverse)

# DATA -----

mpg

# 1.0 HULL PLOT PROGRESSION ----
# - Hull Plots are used to indicate clusters / group assignment

# 1.1 Make the Base Plot ----
g1 <- mpg %>%
    mutate(engine_size = str_c("Cylinder: ", cyl)) %>%
    ggplot(aes(displ, hwy)) +
    geom_point()

g1

# 1.2 Add Cluster Assignments by Engine Size (Cyl) ----
g2 <- g1 +
    geom_mark_hull(
        aes(fill = engine_size, label = engine_size),
        concavity = 2.8
    )

g2


# 1.3 Add Theme and Formatting ----

g3 <- g2 +
    geom_smooth(se = FALSE, span = 1.0) +
    expand_limits(y = 50) +
    theme_tq() +
    scale_fill_tq() +
    labs(
        title = "Fuel Economy (MPG) Trends by Engine Size and Displacement",
        subtitle = "Hull plot to indicate clusters / group assignment",
        y = "Highway Fuel Economy (MPG)",
        x = "Engine Displacement Volume (Liters)",
        fill = "",
        caption = "Engine size has a negative relationship to fuel economy."
    )

g3


# LEARNING MORE ----

# R FOR BUSINESS ANALYSIS COURSE (DS4B 101-R)
# - Learn visualization {ggplot2} in Week 4 (4+ hours just on ggplot)
#   https://university.business-science.io/p/ds4b-101-r-business-analysis-r

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/

