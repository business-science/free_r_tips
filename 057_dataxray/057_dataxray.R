# BUSINESS SCIENCE R TIPS ----
# R-TIP 057 | Exploratory Data X-Ray Analysis (EDXA)  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://github.com/agstn/dataxray

# REQUIREMENTS:

# install.packages("devtools")
# devtools::install_github("agstn/dataxray")

# LIBRARIES ----

library(tidyverse)
library(dataxray)
library(correlationfunnel)

# DATA ----

mpg

# EXPLORATORY DATA X-RAY ANALYSIS (EDXA)!!! ----

# 1. Exploring without groups ----
mpg %>%
    make_xray() %>%
    view_xray()

# 2. Exploring with groups ----
mpg %>%
    make_xray(by = "class") %>%
    view_xray(by = "class")

# ~ Report Functionality ----
# - I had problems creating the report (so I'm skipping this)

# mpg %>%
#     report_xray(
#         data_name = "MPG Dataset",
#         study     = "Vehicle Analysis",
#         loc       = "057_dataxray/"
#     )


# LEARNING MORE ----
# - Has your data science progress has stopped?

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


# BONUS: CORRELATION FUNNEL ----
# - Find quick insights
# - Makes for a great 1-2 combo

mpg %>%
    binarize() %>%
    glimpse() %>%
    correlate(target = hwy__27_Inf) %>%
    plot_correlation_funnel()

