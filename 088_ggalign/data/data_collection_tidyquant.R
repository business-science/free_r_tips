library(tidyquant)
library(tidyverse)

top_50_companies <- read_csv("088_ggalign/data/top_50_companies_by_market_cap.csv")

stock_data <- tq_get(top_50_companies$Ticker, from = "1980-01-01")
stock_data

stock_returns_yearly <- stock_data %>%
    group_by(symbol) %>%
    tq_transmute(
        select = 'adjusted',
        mutate_fun = periodReturn,
        period= "yearly"
    )

stock_returns_wide <- stock_returns_yearly %>%
    ungroup() %>%
    mutate(year = year(date)) %>%
    pivot_wider(
        id_cols = symbol,
        names_from = year,
        values_from = yearly.returns
    )

stock_returns_wide %>%
    left_join(top_50_companies%>% select(Ticker,Company), by = c("symbol" = "Ticker")) %>%
    relocate(Company, 1) %>%
    rename(company = Company) %>%
    mutate(company = str_glue("{company} ({symbol})")) %>%
    select(-symbol) %>%
    write_csv("088_ggalign/data/stock_returns.csv")
