# BUSINESS SCIENCE R TIPS ----
# R-TIP 90 | FORECASTING IN R WITH MODELTIME ----

# Libraries
library(modeltime)
library(tidymodels)
library(tidyverse)
library(timetk)

# Step 1 - Collect data ----

m750 <- m4_monthly %>% filter(id == "M750")

splits <- initial_time_split(m750, prop = 0.9)

# Step 2 - Make Models ----

# Model 1: auto_arima ----
model_fit_arima <- arima_reg() %>%
    set_engine(engine = "auto_arima") %>%
    fit(value ~ date, data = training(splits))

# Model 2: ets ----
model_fit_ets <- exp_smoothing() %>%
    set_engine(engine = "ets") %>%
    fit(value ~ date, data = training(splits))

# Model 3: prophet ----
model_fit_prophet <- prophet_reg() %>%
    set_engine(engine = "prophet") %>%
    fit(value ~ date, data = training(splits))

# Model 4: lm ----
model_fit_lm <- linear_reg() %>%
    set_engine("lm") %>%
    fit(value ~ as.numeric(date) + factor(month(date, label = TRUE), ordered = FALSE),
        data = training(splits))

# Model 5: earth ----

model_spec_mars <- mars(mode = "regression") %>%
    set_engine("earth")

recipe_spec <- recipe(value ~ date, data = training(splits)) %>%
    step_date(date, features = "month", ordinal = FALSE) %>%
    step_mutate(date_num = as.numeric(date)) %>%
    step_normalize(date_num) %>%
    step_rm(date)

wflw_fit_mars <- workflow() %>%
    add_recipe(recipe_spec) %>%
    add_model(model_spec_mars) %>%
    fit(training(splits))

# Step 3 - Modeltime table
models_tbl <- modeltime_table(
    model_fit_arima,
    model_fit_ets,
    model_fit_prophet,
    model_fit_lm,
    wflw_fit_mars
)

models_tbl

# Step 4 - Calibrate with Test Data
calibration_tbl <- models_tbl %>%
    modeltime_calibrate(new_data = testing(splits))

calibration_tbl

# Step 5 - Evaluate

calibration_tbl %>%
    modeltime_forecast(
        new_data    = testing(splits),
        actual_data = m750
    ) %>%
    plot_modeltime_forecast(
        .legend_max_width = 25, # For mobile screens
        .interactive      = TRUE
    )

calibration_tbl %>%
    modeltime_accuracy() %>%
    table_modeltime_accuracy(
        .interactive = FALSE
    )

# Step 6 - Refit and Forecast Future

refit_tbl <- calibration_tbl %>%
    modeltime_refit(data = m750)

refit_tbl %>%
    modeltime_forecast(h = "3 years", actual_data = m750) %>%
    plot_modeltime_forecast(
        .legend_max_width = 25, # For mobile screens
        .interactive      = TRUE
    )

# WANT BECOME THE TIME SERIES EXPERT FOR YOUR COMPANY? ----
# I made a High-Performance Forecasting Course
# It comes with 549 Lessons, 45.8 Hours of Video Content, and 3 Challenges to test your skills
# Enroll here: https://university.business-science.io/p/ds4b-203-r-high-performance-time-series-forecasting
