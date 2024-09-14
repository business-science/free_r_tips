


library(summarytools)
library(tidyverse)

stock_data_tbl <- read_csv("084_summarytools/data/stock_data.csv")
stock_data_tbl

# Calculate returns (percentage change)
stock_returns_tbl <- stock_data_tbl %>%
    arrange(Date) %>%
    mutate(across(-Date, ~ (./lag(.) - 1))) %>%
    drop_na()

stock_returns_tbl

# DF Summary ----
stock_returns_tbl %>%
    dfSummary(
        graph.col = TRUE,
        style="grid",
        graph.magnif = 0.75,
    ) %>%
    stview()

# Describe ----
stock_returns_tbl %>% descr() %>% stview()

