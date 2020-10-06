# R TIPS ----
# TIP 006: Excel Pivot Tables in R ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# 1.0 LIBRARIES ----

library(tidyquant)
library(tidyverse)
library(gt)

# 2.0 GET DATA ----

stock_data_tbl <- c("AAPL", "GOOG", "NFLX", "NVDA") %>%
    tq_get(from = "2010-01-01", to = "2019-12-31") %>%
    select(symbol, date, adjusted)

# 3.0 PIVOT TABLE - Percent Change by Year ----

# * Basics ----

stock_data_tbl %>%
    pivot_table(
        .rows    = c(~ symbol, ~ MONTH(date, label = TRUE)),
        .columns = ~ YEAR(date),
        .values  = ~ MEDIAN(adjusted)
    ) %>%
    rename_at(.vars = 1:2, ~ c("Symbol", "Month"))

stock_data_tbl %>%
    pivot_table(
        .rows    = c(~ YEAR(date), ~ MONTH(date, label = TRUE)),
        .columns = symbol,
        .values  = ~ MEDIAN(adjusted)
    ) %>%
    rename_at(.vars = 1:2, ~ c("Year", "Month"))

stock_data_tbl %>%
    pivot_table(
        .columns = ~ MONTH(date, label = TRUE),
        .rows    = c(~ YEAR(date), symbol),
        .values  = ~ MEDIAN(adjusted)
    ) %>%
    rename(Year = 1)


# * Percent Change by Year ----
stock_performance_tbl <- stock_data_tbl %>%
    pivot_table(
        .rows    = ~ YEAR(date),
        .columns = ~ symbol,
        .values  = ~ PCT_CHANGE_FIRSTLAST(adjusted)
    ) %>%
    rename(YEAR = 1)

# 4.0 PIVOT CHARTS ----

color_fill <- "#1ecbe1"

pivot_table_gt <- stock_performance_tbl %>%
    gt() %>%
    tab_header("Stock Returns", subtitle = md("_Technology Portfolio_")) %>%
    fmt_percent(columns = vars(AAPL, GOOG, NFLX, NVDA)) %>%
    tab_spanner(
        label = "Performance",
        columns = vars(AAPL, GOOG, NFLX, NVDA)
    ) %>%
    tab_source_note(
        source_note = md("_Data Source:_ Stock data retreived from Yahoo! Finance via tidyquant.")
    ) %>%
    tab_style(
        style = list(
            cell_fill(color = color_fill),
            cell_text(weight = "bold", color = "white")
        ),
        locations = cells_body(
            columns = vars(AAPL),
            rows    = AAPL >= 0)
    ) %>%
    tab_style(
        style = list(
            cell_fill(color = color_fill),
            cell_text(weight = "bold", color = "white")
        ),
        locations = cells_body(
            columns = vars(GOOG),
            rows    = GOOG >= 0)
    ) %>%
    tab_style(
        style = list(
            cell_fill(color = color_fill),
            cell_text(weight = "bold", color = "white")
        ),
        locations = cells_body(
            columns = vars(NFLX),
            rows    = NFLX >= 0)
    ) %>%
    tab_style(
        style = list(
            cell_fill(color = color_fill),
            cell_text(weight = "bold", color = "white")
        ),
        locations = cells_body(
            columns = vars(NVDA),
            rows    = NVDA >= 0)
    )

pivot_table_gt

# 5.0 SAVING THE CHART ----
# - Requires Phantom JS

# webshot::install_phantomjs()
pivot_table_gt %>%
    gtsave(filename = "006_pivot_tables/stock_returns.png")
