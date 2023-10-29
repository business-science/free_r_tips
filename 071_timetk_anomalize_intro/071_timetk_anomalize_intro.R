# BUSINESS SCIENCE R TIPS ----
# R-TIP 71 | Introducing Anomalize for TimeTK in R ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# NOTE: Requires timetk >= 2.8.4.9000
# remotes::install_github("business-science/timetk")

# Libraries
library(tidyverse)
library(timetk) # Requires timetk >= 2.8.4.9000

# Data
stock_data_tbl <- read_csv("071_timetk_anomalize_intro/data/stock_data.csv")
stock_data_tbl

# 1.0 ANOMALIZE ----

stock_data_anomalized_tbl <- stock_data_tbl %>%
    filter_by_time(date, "2018") %>%
    group_by(symbol) %>%
    anomalize(date, adjusted) %>%
    ungroup()

stock_data_anomalized_tbl %>% glimpse()

stock_data_anomalized_tbl %>% filter(anomaly == "Yes")

# 2.0 VISUALIZE ANOMALIES -----

stock_data_anomalized_tbl %>%
    group_by(symbol) %>%
    plot_anomalies(date)

# 3.0 UNDERSTANDING ANOMALIZATION PROCESS -----

stock_data_anomalized_tbl %>%
    group_by(symbol) %>%
    plot_anomalies_decomp(date)

# 4.0 [NEW] CLEANING ANOMALIES ----

stock_data_anomalized_tbl %>%
    group_by(symbol) %>%
    plot_anomalies_cleaned(date)


# 5.0 LEARN MORE RIGHT NOW! ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass



