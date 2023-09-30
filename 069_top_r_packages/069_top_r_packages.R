# BUSINESS SCIENCE R TIPS ----
# R-TIP 069 | Top 9 R packages ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# 1. tidyverse -----
# Loads dplyr, ggplot2, tidyr, readr, stringr, lubridate, purrr and more.
library(tidyverse)

# 2. dplyr ----
library(dplyr)

# Sample Data Frame
data <- tibble(
    Product = c('A', 'B', 'C', 'A', 'C'),
    Sales = c(100, 150, 200, 50, 300)
)

# Summarizing Total Sales per Product
data %>%
    group_by(Product) %>%
    summarize(Total_Sales = sum(Sales))

# 3. ggplot2 ----
library(ggplot2)

# Sample Data Frame
data <- tibble(
    Month = c('Jan', 'Feb', 'Mar') %>% as_factor(),
    Revenue = c(2000, 2500, 3000)
)

# Bar Plot of Monthly Revenue
ggplot(data, aes(x = Month, y = Revenue)) +
    geom_bar(stat = 'identity', fill = '#2C3E50') +
    labs(title = 'Monthly Revenue')

# 4. tidyr ----
library(tidyr)

# Sample Data Frame
data <- tibble(
    Date = c('2023-01-01', '2023-02-01'),
    'Product A' = c(100, 150),
    'Product B' = c(200, 250)
)

# Pivotting Product columns into long format
data %>%
    pivot_longer(cols = -Date)

# 5. timetk ----
library(timetk)

FANG %>%
    group_by(symbol) %>%
    plot_time_series(
        date, adjusted,
        .interactive = TRUE,
        .trelliscope = TRUE
    )

# 6. readr ----
library(readr)

# Reading a CSV file containing financial data

financial_data <- read_csv("069_top_r_packages/data/walmart_sales.csv")

# 7. Tidymodels ----
library(tidymodels)

# Sample Data Frame
data <- tibble(
    Marketing_Spend = c(1000, 1500, 2000, 2500, 3000),
    Sales = c(2000, 3000, 4000, 5000, 6000)
)

# Linear Regression Model to predict Sales based on Marketing Spend
linear_model <- linear_reg() %>%
    set_engine('lm') %>%
    fit(Sales ~ Marketing_Spend, data = data)

linear_model %>% predict(tibble(Marketing_Spend = 4000))

# 8. Leaflet ----
library(leaflet)

# Sample Data Frame with Latitude and Longitude
data <- tibble(
    Store = c('Store 1', 'Store 2'),
    Lat = c(37.7749, 34.0522),
    Lng = c(-122.4194, -118.2437)
)

# Creating an interactive map with store locations
leaflet(data) %>%
    addTiles() %>%
    addMarkers(~Lng, ~Lat, popup = ~Store)

# 9. BONUS 1: Shiny App ----
# SEE Interactive Store Locator: shiny_app.R

# BONUS 2: LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass



