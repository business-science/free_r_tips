# R TIPS ----
# TIP 028 | Esquisse ggplot builder ---
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

library(esquisse)
library(modeldata)
library(tidyverse)

# LOAD SOME DATA ----
data("drinks")
data("mpg")

drinks

mpg

# RUN ESQUISSE ----
esquisser()


drinks %>%
    filter(date >= "2005-01-14" & date <= "2014-01-22") %>%
    ggplot() +
    aes(x = date, y = S4248SM144NCEN) +
    geom_line(size = 1.34, colour = "#909495") +
    labs(title = "My awesome plot", subtitle = "This is a time series") +
    theme_minimal()

ggplot(mpg) +
    aes(x = displ, y = hwy, colour = drv) +
    geom_point(size = 3L) +
    geom_smooth(span = 1L) +
    scale_color_viridis_d(option = "cividis") +
    theme_minimal()
