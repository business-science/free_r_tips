# BUSINESS SCIENCE R TIPS ----
# R-TIP 065 | Tables in R with gt and gtExtras  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter
#
# **** -----

# GOAL: Improve Your Ability to Make Professional Tables

# LIBRARIES ----

# Professional Tables
library(gt)
library(gtExtras)

# Data Import & Transformation
library(tidyverse)
library(readxl)
library(janitor)

# DATA ----

cashflow_raw_tbl <- read_excel(
    path  = "065_gt_financial_tables/data/financial-statements-exxon-mobil.xlsx",
    sheet = 1,
    skip  = 1
)

cashflow_raw_tbl


# 1.0 DATA PREPARATION ----

cashflow_wide_tbl <- cashflow_raw_tbl %>%
    clean_names() %>%
    rowid_to_column("item_id") %>%
    rename(item_name = in_million_usd) %>%
    mutate(group_id = c(1,1,1,1,1, 2,2,2,2, 3,3,3,3,3, 4,4,4)) %>%
    mutate(item_type = c(
        rep("input", 4), "output",
        rep("input", 3), "output",
        rep("input", 4), "output",
        "output", "input", "output"
    )) %>%
    select(group_id, starts_with("item"), everything()) %>%
    mutate(across(starts_with("fy_"), ~ replace_na(., 0))) %>%

    # For Sparklines
    rowwise() %>%
    mutate(trend = list(c_across(fy_09:fy_18))) %>%
    ungroup()

cashflow_wide_tbl


# 2.0 TABLE WITH GT & GTEXTRAS ----

cashflow_wide_tbl %>%
    gt() %>%
    gtExtras::gt_plt_sparkline(trend) %>%
    tab_header(
        title    = "Cash Flow Statement",
        subtitle = "Exxon Mobil (FY2009 - FY2018)"
    ) %>%
    tab_spanner(
        label   = "Fiscal Year (Values in Millions)",
        columns = fy_09:fy_18,
    ) %>%
    cols_label(
        item_id   = "Item No.",
        item_name = "Item Name",
        item_type = "Item Type",
        fy_09     = "2009",
        fy_10     = "2010",
        fy_11     = "2011",
        fy_12     = "2012",
        fy_13     = "2013",
        fy_14     = "2014",
        fy_15     = "2015",
        fy_16     = "2016",
        fy_17     = "2017",
        fy_18     = "2018",
        trend     = "Trend"
    ) %>%
    fmt_currency(
        columns    = fy_09:fy_18,
        decimals   = 0,
        accounting = TRUE
    ) %>%
    cols_align(align = "center") %>%
    gtExtras::gt_highlight_rows(
        rows = item_type == "output",
        fill = "lightgrey"
    ) %>%
    cols_hide(columns = c(item_type, group_id)) %>%
    tab_options(
        heading.title.font.size    = 20,
        table.font.size            = 13,
        heading.subtitle.font.size = 12,
        column_labels.font.weight  = "bold",
    )




# 3.0 LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass



