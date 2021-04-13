# R TIPS ----
# TIP 032 | datapasta: Copy & Paste from any HTML or Excel Table ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

library(datapasta)
library(tidyverse)
library(lubridate)
library(timetk)

# 1.0 Stock Data ----
# - https://finance.yahoo.com/quote/AAPL/history
stock_data <- tibble::tribble(
             ~Date,  ~Open,  ~High,   ~Low, ~`Close*`, ~`Adj.Close**`,     ~Volume,
    "Apr 12, 2021", 132.52, 132.85, 130.63,    131.24,         131.24,    85546001,
    "Apr 09, 2021",  129.8, 133.04, 129.47,       133,            133,   106513800,
    "Apr 08, 2021", 128.95, 130.39, 128.52,    130.36,         130.36,    88844600,
    "Apr 07, 2021", 125.83, 127.92, 125.14,     127.9,          127.9,    83466700,
    "Apr 06, 2021",  126.5, 127.13, 125.65,    126.21,         126.21,    80171300,
    "Apr 05, 2021", 123.87, 126.16, 123.07,     125.9,          125.9,    88651200
    )

stock_data %>%
    mutate(Date = mdy(Date)) %>%
    plot_time_series(Date, Volume)



# 2.0 Largest Companies by Revenue ----
# - https://en.wikipedia.org/wiki/List_of_largest_companies_by_revenue

largest_companies_dt = data.table::data.table(
          V1 = c(1L, 2L, 3L, 4L, 5L, 6L),
          V2 = c("Walmart","Sinopec Group","Amazon",
                 "State Grid","China National Petroleum","Royal Dutch Shell"),
          V3 = c("Retail","Oil and gas","Retail",
                 "Electricity","Oil and gas","Oil and gas"),
          V4 = c("Increase $559,200","Decrease $407,009",
                 "Increase $386,064","Decrease $383,906","Decrease $379,130",
                 "Decrease $344,379"),
          V5 = c("$19,742", "$6,793", "$17,377", "$7,970", "$4,433", "$15,842"),
          V6 = c(2200000, 582648, 1125300, 907677, 1344410, 83000),
          V7 = c("United States United States",
                 "China China","United States United States","China China","China China",
                 "Netherlands Netherlands"),
          V8 = c("[4]", "[5]", "[6]", "[7]", "[8]", "[9]")
)

largest_companies_dt %>%
    mutate(V4 = parse_number(V4)) %>%
    ggplot(aes(V4, V2)) +
    geom_col(aes(fill = V4)) +
    theme_minimal()


