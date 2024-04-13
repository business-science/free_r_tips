library(tidyverse)
library(lubridate)
library(timetk)
library(modeltime)
library(tidymodels)

# Example data creation
set.seed(123)
date_seq <- seq(as.Date("2020-01-01"), as.Date("2021-12-31"), by="day")
data <- tibble(
    date = date_seq,
    demand = round(100 + sin(seq_along(date_seq)/20) * 50 + rnorm(length(date_seq), mean = 0, sd = 10))
)

# Convert date column to a proper date format and ensure it's sorted
data <- data %>%
    mutate(date = as.Date(date)) %>%
    arrange(date)

# Split the data into training and testing
split_date <- as.Date("2021-06-01")
train_data <- data %>% filter(date < split_date)
test_data <- data %>% filter(date >= split_date)


# Define the recipe
recipe_spec <- recipe(demand ~ date, data = train_data) %>%
    step_timeseries_signature(date) %>%
    step_fourier(date, period = 365, K = 2) %>%
    step_rm(date) %>%
    step_dummy(all_nominal_predictors(), one_hot = TRUE)


# Define the model
model_spec <- boost_tree() %>%
    set_engine("xgboost") %>%
    set_mode("regression")

# Fit the model
model_fit <- workflow() %>%
    add_model(model_spec) %>%
    add_recipe(recipe_spec) %>%
    fit(train_data)

# Create future dataframe for forecasting
future_dates <- tibble(date = seq(max(train_data$date) + 1, by="day", length.out=180))

# Forecast
forecast <- modeltime_table(model_fit) %>%
    modeltime_forecast(new_data = future_dates, actual_data = train_data)

# Plot the results
forecast %>%
    plot_modeltime_forecast(
        .legend_show = TRUE,
        .interactive = FALSE
    )
