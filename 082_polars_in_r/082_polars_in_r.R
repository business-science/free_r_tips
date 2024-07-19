# BUSINESS SCIENCE R TIPS ----
# R-TIP 82 | POLARS IN R ----

# LIBRARIES & DATA

# install.packages("polars", repos = "https://community.r-multiverse.org")

library(polars)
library(tidyverse)
library(timetk)

stock_data_pl = pl$read_csv("082_polars_in_r/stock_data.csv")


# 1. PIVOT TO LONG FORMAT ----

long_pl = stock_data_pl$unpivot(
    index         = "Date",
    value_name    = "Price",
    variable_name = "Stock"
)
long_pl

long_pl %>%
    as_tibble() %>%
    group_by(Stock) %>%
    plot_time_series(as_date(Date), Price, .facet_ncol = 4, .smooth = FALSE)

# 2. MOVING AVERAGES ----

moving_average_pl = long_pl$with_columns(
    pl$col("Price")$rolling_mean(10)$over("Stock")$alias("Price_MA10"),
    pl$col("Price")$rolling_mean(50)$over("Stock")$alias("Price_MA50")
)
moving_average_pl

moving_average_pl %>%
    as_tibble() %>%
    pivot_longer(
        cols = Price:Price_MA50
    ) %>%
    group_by(Stock) %>%
    plot_time_series(as_date(Date), value, .color_var = name, .facet_ncol = 4, .smooth = FALSE)

# FREE R MASTERCLASS:
# 👉 WATCH HERE: https://learn.business-science.io/free-rtrack-masterclass?el=website

