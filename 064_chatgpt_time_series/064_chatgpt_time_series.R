# BUSINESS SCIENCE R TIPS ----
# R-TIP 064 | ChatGPT for Time Series in R  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter
#
# **** -----

# GOAL: Improve Your Ability to do Time Series with ChatGPT

# INITIAL PROMPT:
# How do I use the modeltime R package to forecast?
# Provide an example using that includes a horizon of the next 30 days
# for a daily time series dataset containing the columns date and value.
# Make sure to include a visualization of the forecast.

# LIBRARIES ----

library(tidyverse)
library(lubridate)
library(timetk)
library(modeltime)
library(tidymodels)

# Load or create your dataset
data <- read_csv("064_chatgpt_time_series/data/time_series.csv")

# 1.0 FIX 1: I ADD A VISUAL ----
data %>% plot_time_series(date, value)

# Split the data
splits <- initial_time_split(data, prop = 0.8)

# Define the model
arima_spec <- arima_reg() %>%
    set_engine("auto_arima") %>%
    set_mode("regression")

# 2.0 FIX 2: RECIPE INSTEAD OF FORMULA ----

# Fit the model
# arima_fit <- workflow() %>%
#     add_model(arima_spec) %>%
#     add_formula(value ~ date) %>%
#     fit(data = training(splits))

# Define a recipe
rec <- recipe(value ~ date, data = training(splits))

# Fit the model
arima_fit <- workflow() %>%
    add_model(arima_spec) %>%
    add_recipe(rec) %>%
    fit(data = training(splits))

# Calibrate the model
arima_cal <- modeltime_calibrate(arima_fit, testing(splits))

# 3.0 FIX 3: arima_cal IS ALREADY A MODELTIME TABLE ----

# # Create a future frame
# future_frame <- modeltime_table(arima_cal) %>%
#     modeltime_future(new_data = testing(splits),
#                      future_length = 30)  # 30 day forecast
#
# # Generate a forecast
# arima_forecast <- modeltime_table(arima_cal) %>%
#     modeltime_forecast(new_data = future_frame)

arima_forecast <- arima_cal %>%
    modeltime_forecast(
        new_data    = testing(splits),
        actual_data = data
    )

# Print the forecast
arima_forecast

# Plot the forecast
arima_forecast %>%
    # had to fix this
    # plot_modeltime_forecast(.legend_fill = "Model ID")
    plot_modeltime_forecast()

# 4.0 FIX 4: I HAD TO ASK TO RECALIBRATE / REFIT AND FORECAST ----
#  NEXT 30 DAYS INTO THE FUTURE
#  (I HAD TO FIX THIS CODE SUBSTANTIALLY)

# Recalibrate the model using the testing data
arima_fit_full <- modeltime_refit(arima_cal, data = data)

# Generate a forecast
arima_forecast_full <- arima_fit_full %>%
    modeltime_forecast(
        # ChatGPT didn't recognize the future_frame (came up with modeltime_future)
        new_data = future_frame(data, .length_out = 30),
        actual_data = data
    )

# Print the recalibrated forecast
arima_forecast_full

# Plot the recalibrated forecast
arima_forecast_full %>%
    # had to fix this
    # plot_modeltime_forecast(.legend_fill = "Model ID")
    plot_modeltime_forecast()

# LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass
