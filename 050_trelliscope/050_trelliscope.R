# BUSINESS SCIENCE R TIPS ----
# R-TIP 050 | Trelliscope JS: Interactive Data Visualization with ggplot  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://hafen.github.io/trelliscopejs/

# INSTALLATION ----
# install.packages("trelliscopejs")


# LIBRARIES ----

library(tidyverse)
library(plotly)
library(trelliscopejs)

# DATA ----

mpg

# 1.0 GGPLOT ----
# - Add Labels: Displ Min/Max, Hwy Min/Max/Mean

mpg %>%
    ggplot(aes(displ, hwy)) +
    geom_point(size = 4) +
    geom_smooth(se = FALSE, span = 1) +
    facet_trelliscope(
        ~ manufacturer,
        ncol      = 4,
        nrow      = 3
    )


# 2.0 MEGA BONUS: INTERACTIVE (plotly) ----

mpg %>%
    ggplot(aes(displ, hwy)) +
    geom_point() +
    geom_smooth(se = FALSE, span = 1) +
    facet_trelliscope(
        ~ manufacturer,
        ncol      = 4,
        nrow      = 3,
        as_plotly = TRUE
    )



# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

