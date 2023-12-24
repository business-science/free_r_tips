# BUSINESS SCIENCE R TIPS ----
# R-TIP 75 | Time Series Analysis ----

# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# 👉 Do you want to become the data science expert for your organization?
#   HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

# 👉 High-Performance Time Series Course:
#  https://university.business-science.io/p/ds4b-203-r-high-performance-time-series-forecasting?el=newsletter

# LIBRARIES and DATA ----

library(tidyverse)
library(timetk)

ts_tbl <- read_csv("075_time_series_analysis/d10.csv")

# 5 TIME SERIES ANALYSIS VISUALIZATIONS -----

# 1: Time Series Plot ----
ts_tbl %>%
    plot_time_series(date, value, .smooth = F, .interactive = F)

# 2: Time Series Plot (with Trend) ----
ts_tbl %>%
    plot_time_series(date, value, .smooth = T, .smooth_span = 0.3, .interactive = F)

# 3: Autocorrelation and Partial Autocorrelation ----

ts_tbl %>%
    plot_acf_diagnostics(date, value, .interactive = F, .lags = 1:60)

# 4: Seasonal Decomposition (STL) -----
ts_tbl %>%
    plot_stl_diagnostics(
        date, value,
        .feature_set = c("observed", "season", "trend", "remainder"),
        .trend       = 180,
        .frequency   = 30,
        .interactive = F
    )

# 5: Calendar Features ----
ts_tbl %>%
    plot_seasonal_diagnostics(date, value, .interactive = F)


# BONUS: Price of oil visualization ----

library(tidyquant)

tq_get("DCOILWTICO", get = "economic.data", from = "2013-01-01", to = "2018-06-01") %>%
    group_by(symbol) %>%
    plot_time_series(date, price, .interactive = F, .y_intercept = 0, .title = "Price of Oil")

