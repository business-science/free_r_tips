# BUSINESS SCIENCE R TIPS ----
# R-TIP 054 | explore: simplified exploratory data analysis ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://github.com/rolkra/explore

# LIBRARIES ----

library(tidyverse)
library(explore)

# DATA ----

mpg

# EXPLORE ----

# * Shiny App ----

mpg %>% explore()

mpg %>% select(-cty) %>% explore()

# * Describe ----

mpg %>% describe_all()

mpg %>% describe_cat(manufacturer)

# * Explore All Variables ----

mpg %>%
    explore_all(
        target = hwy,
        ncol   = 3
    )

# * Explore Bivariate Plot ----
mpg %>%
    explore(
        target = hwy,
        var    = hwy,
        var2   = manufacturer
    )

# * Reporting ----
mpg %>%
    report(
        target      = hwy,
        output_dir  = "054_explore/",
        output_file = "explore_plots.html"
    )

# LEARNING MORE ----
# - Has your data science progress has stopped?

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass
