# R TIPS ----
# TIP 032 | datapasta: Copy & Paste HTML or Excel Tables ----
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
                  "Apr 12, 2021", 132.52, 132.85, 130.63,    131.24,         131.24,    91286600,
                  "Apr 09, 2021",  129.8, 133.04, 129.47,       133,            133,   106513800,
                  "Apr 08, 2021", 128.95, 130.39, 128.52,    130.36,         130.36,    88844600,
                  "Apr 07, 2021", 125.83, 127.92, 125.14,     127.9,          127.9,    83466700,
                  "Apr 06, 2021",  126.5, 127.13, 125.65,    126.21,         126.21,    80171300,
                  "Apr 05, 2021", 123.87, 126.16, 123.07,     125.9,          125.9,    88651200,
                  "Apr 01, 2021", 123.66, 124.18, 122.49,       123,            123,    74957400,
                  "Mar 31, 2021", 121.65, 123.52, 121.15,    122.15,         122.15,   118323800,
                  "Mar 30, 2021", 120.11,  120.4, 118.86,     119.9,          119.9,    85671900,
                  "Mar 29, 2021", 121.65, 122.58, 120.73,    121.39,         121.39,    80819200,
                  "Mar 26, 2021", 120.35, 121.48, 118.92,    121.21,         121.21,    93958900,
                  "Mar 25, 2021", 119.54, 121.66,    119,    120.59,         120.59,    98844700,
                  "Mar 24, 2021", 122.82,  122.9, 120.07,    120.09,         120.09,    88530500,
                  "Mar 23, 2021", 123.33, 124.24, 122.14,    122.54,         122.54,    95467100,
                  "Mar 22, 2021", 120.33, 123.87, 120.26,    123.39,         123.39,   111912300
                  )



stock_data %>%
    mutate(Date = mdy(Date)) %>%
    plot_time_series(Date, Volume)



# 2.0 Largest Companies by Revenue ----
# - https://en.wikipedia.org/wiki/List_of_largest_companies_by_revenue

largest_companies_dt <- data.table::data.table(
                                  V1 = c(1L,2L,3L,4L,5L,6L,7L,8L,9L,
                                         10L),
                                  V2 = c("Walmart","Sinopec Group",
                                         "Amazon","State Grid",
                                         "China National Petroleum","Royal Dutch Shell",
                                         "Saudi Aramco","Volkswagen","BP","Toyota"),
                                  V3 = c("Retail","Oil and gas","Retail",
                                         "Electricity","Oil and gas",
                                         "Oil and gas","Oil and gas","Automotive",
                                         "Oil and gas","Automotive"),
                                  V4 = c("Increase $559,200",
                                         "Decrease $407,009","Increase $386,064",
                                         "Decrease $383,906","Decrease $379,130",
                                         "Decrease $344,379","Decrease $329,784",
                                         "Increase $282,760","Decrease $282,610",
                                         "Increase $275,288"),
                                  V5 = c("$19,742","$6,793","$17,377",
                                         "$7,970","$4,433","$15,842","$88,211",
                                         "$15,542","$4,026","$19,096"),
                                  V6 = c(2200000,582648,1125300,907677,
                                         1344410,83000,79000,671205,72500,
                                         359542),
                                  V7 = c("United States United States",
                                         "China China",
                                         "United States United States","China China","China China",
                                         "Netherlands Netherlands",
                                         "Saudi Arabia Saudi Arabia","Germany Germany",
                                         "United Kingdom United Kingdom","Japan Japan"),
                                  V8 = c("[4]","[5]","[6]","[7]","[8]",
                                         "[9]","[10]","[11]","[12]","[13]")
                        )

largest_companies_dt %>%
    mutate(
        V4 = parse_number(V4),
        V2 = as_factor(V2) %>% fct_rev()
    ) %>%
    ggplot(aes(V4, V2)) +
    geom_col(aes(fill = V4)) +
    geom_label(aes(label = scales::dollar_format()(V4)), hjust=1) +
    theme_minimal() +
    scale_x_continuous(labels = scales::dollar_format()) +
    labs(title = "Revenue (Millions) for Largest Companies") +
    theme(legend.position = 'none')

# LEARNING RECOMMENDATIONS ----
# 1. Learning tidyverse foundations - R for Business Analysis DS4B 101-R
# 2. Learning Time Series - High-Performance Time Series DS4B 203-R
# 3. 5-Course R-Track (go from beginner to expert)

