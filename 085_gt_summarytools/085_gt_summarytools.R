# BUSINESS SCIENCE R TIPS ----
# R-TIP 85 | ANALYZE DATA FASTER WITH R (PART 2) ----

# LIBRARIES & DATA ----

library(tidyverse)
library(gt)
library(gtExtras)
library(summarytools)

# DATASETS:

churn_data_tbl <- read_csv("085_gtExtras/data/customer_churn.csv")

stock_data_tbl <- read_csv("085_gtExtras/data/stock_data.csv")


# 1.0 SUMMARY PLOT (GTEXTRAS) ----

churn_data_tbl %>%
    select(-customerID) %>%
    gt_plt_summary("Churn Data Summary") %>%
    gtExtras::gt_theme_538()

stock_data_tbl %>%
    gt_plt_summary("Stock Data Summary") %>%
    gtExtras::gt_theme_538()

# 2.0 SUMMARYTOOLS DF SUMMARY ----

summarytools::dfSummary(churn_data_tbl) %>% stview()

summarytools::dfSummary(stock_data_tbl) %>% stview()

# 3.0 GT SUMMARYTOOLS ----
# * CUSTOM FUNCTION THAT REPLICATES SUMMARYTOOLS DFSUMMARY() FROM R-TIP 84 ----

source("085_gt_summarytools/gt_summarytools.R")

churn_data_tbl %>%
    select(-customerID) %>%
    gt_summarytools("Customer Churn Summary") %>%
    gt_theme_538()

stock_data_tbl %>%
    gt_summarytools("Stock Data Summary") %>%
    gt_theme_538()
