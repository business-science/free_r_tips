# BUSINESS SCIENCE R TIPS ----
# R-TIP 046| furrr: Parallel Processing ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

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

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass
