# R TIPS ----
# TIP 039 | Introduction to Modeltime: In 2-Minutes ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

library(modeltime)
library(tidymodels)
library(tidyverse)
library(timetk)
library(lubridate)

# DATA ----

bike_sharing_daily

data <- bike_sharing_daily %>%
    select(dteday, cnt)

data

data %>% plot_time_series(dteday, cnt)

# FORECAST ----

# * ARIMA ---
model_arima <- arima_reg(seasonal_period = 52) %>%
    set_engine("auto_arima") %>%
    fit(cnt ~ dteday, data)

model_arima

# * Prophet ----
model_prophet <- prophet_reg() %>%
    set_engine("prophet") %>%
    fit(cnt ~ dteday, data)

model_prophet

# * Machine Learning - GLM ----
model_glmnet <- linear_reg(penalty = 0.01) %>%
    set_engine("glmnet") %>%
    fit(
        cnt ~ month(dteday, label = TRUE) + wday(dteday, label = TRUE) + as.numeric(dteday),
        data
    )

# MODELTIME COMPARE ----

model_tbl <- modeltime_table(
    model_arima,
    model_prophet,
    model_glmnet
)

model_tbl %>%
    modeltime_forecast(
        h           = "1 year",
        actual_data = data
    ) %>%
    plot_modeltime_forecast()
