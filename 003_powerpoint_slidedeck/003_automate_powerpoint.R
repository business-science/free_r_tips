# R TIPS ----
# TIP 003: Automate PowerPoint Slide Decks with R ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# 1.0 LIBRARIES ----
library(officer)
library(flextable)
library(tidyverse)
library(tidyquant)
library(timetk)

# 2.0 DATA ----
# - Use tidyquant to pull in some stock data

stock_data_tbl <- c("AAPL", "GOOG", "FB", "NVDA") %>%
    tq_get(from = "2019-01-01", to = "2020-08-31")


# 3.0 DATA WRANGLING ----
# - dplyr (DS4B 101-R Weeks 2 & 3)

stock_returns_tbl <- stock_data_tbl %>%
    select(symbol, date, adjusted) %>%
    group_by(symbol) %>%
    summarise(
        week    = last(adjusted) / first(tail(adjusted, 7)) - 1,
        month   = last(adjusted) / first(tail(adjusted, 30)) - 1,
        quarter = last(adjusted) / first(tail(adjusted, 90)) - 1,
        year    = last(adjusted) / first(tail(adjusted, 365)) - 1,
        all     = last(adjusted) / first(adjusted) - 1
    )

# 4.0 PLOTS & TABLES ----
# - ggplot2 (DS4B 101-R Weeks 4)

# * Stock Plot ----
stock_plot <- stock_data_tbl %>%
    group_by(symbol) %>%
    summarize_by_time(adjusted = AVERAGE(adjusted), .by = "week") %>%
    plot_time_series(date, adjusted, .facet_ncol = 2, .interactive = FALSE)

stock_plot

# * Stock Return Table -----
stock_table <- stock_returns_tbl %>%
    rename_all(.funs = str_to_sentence) %>%
    mutate_if(is.numeric, .funs = scales::percent) %>%
    flextable::flextable()

stock_table


# 5.0 MAKE A POWERPOINT DECK -----

doc <- read_pptx()
doc <- add_slide(doc)
doc <- ph_with(doc, value = "Stock Report", location = ph_location_type(type = "title"))
doc <- ph_with(doc, value = stock_table, location = ph_location_left())
doc <- ph_with(doc, value = stock_plot, location = ph_location_right())

print(doc, target = "003_powerpoint_slidedeck/stock_report.pptx")
