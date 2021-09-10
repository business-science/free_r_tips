# R TIPS ----
# TIP 046| furrr: Parallel Processing ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://mailchi.mp/business-science/r-tips-newsletter

# furrr package: https://furrr.futureverse.org/

# LIBRARIES ----

library(tidyverse)
library(timetk)
library(lubridate)
library(furrr)
library(tictoc)

# DATA ----

sales_data_tbl <- walmart_sales_weekly %>%
    select(id, Date, Weekly_Sales) %>%
    set_names(c("id", "date", "value"))

# 1.0 PURRR ----

tic()
sales_data_tbl %>%
    nest(data = c(date, value)) %>%
    mutate(model = map(data, function(df) {
        Sys.sleep(1)
        lm(value ~ month(date) + as.numeric(date), data = df)
    }))
toc()

# 2.0 FURRR (Parallel Processing) ----
plan(multisession, workers = 6)

tic()
sales_data_tbl %>%
    nest(data = c(date, value)) %>%
    mutate(model = future_map(data, function(df) {
        Sys.sleep(1)
        lm(value ~ month(date) + as.numeric(date), data = df)
    }))
toc()

# LEARNING MORE ----

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/

