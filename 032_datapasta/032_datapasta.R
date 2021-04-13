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
stock_data <-


stock_data %>%
    mutate(Date = mdy(Date)) %>%
    plot_time_series(Date, Volume)



# 2.0 Largest Companies by Revenue ----
# - https://en.wikipedia.org/wiki/List_of_largest_companies_by_revenue

largest_companies_dt <- data.table::data.table(
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

