# R TIPS ----
# TIP 005: Automate Excel Workbooks with R ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# 1.0 LIBRARIES ----

library(openxlsx)
library(tidyquant)
library(tidyverse)
library(timetk)

# 2.0 GET DATA ----

stock_data_tbl <- c("AAPL", "GOOG", "NFLX", "NVDA") %>%
    tq_get(from = "2010-01-01", to = "2019-12-31")

stock_pivot_table <- stock_data_tbl %>%
    pivot_table(
        .rows    = ~ YEAR(date),
        .columns = ~ symbol,
        .values  = ~ PCT_CHANGE_FIRSTLAST(adjusted)
    ) %>%
    rename(year = 1)

stock_plot <- stock_data_tbl %>%
    group_by(symbol) %>%
    plot_time_series(date, adjusted, .color_var = symbol, .facet_ncol = 2, .interactive = FALSE)

# 3.0 CREATE WORKBOOK ----

# * Initialize a workbook ----
wb <- createWorkbook()

# * Add a Worksheet ----
addWorksheet(wb, sheetName = "stock_analysis")

# * Add Plot ----

print(stock_plot)

wb %>% insertPlot(sheet = "stock_analysis", startCol = "G", startRow = 3)

# * Add Data ----

writeDataTable(wb, sheet = "stock_analysis", x = stock_pivot_table)

# * Save Workbook ----
saveWorkbook(wb, "005_excel_workbook/stock_analysis.xlsx", overwrite = TRUE)

# * Open the Workbook ----
openXL("005_excel_workbook/stock_analysis.xlsx")
