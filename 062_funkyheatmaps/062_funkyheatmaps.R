# BUSINESS SCIENCE R TIPS ----
# R-TIP 062 | Funky Heat Maps  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter
#
# **** -----

# GOAL: Improve Storytelling Of Complex Financial Plots

library(tidyverse)
library(funkyheatmap)

# DATA ----

sector_performance_tbl <- read_csv("062_funkyheatmaps/sector_performance.csv")

sector_performance_tbl

# 1.0 BASIC FUNKY HEAT MAP ----

sector_performance_tbl %>%
    rename(id = sector_name) %>%
    funky_heatmap()


sector_performance_tbl %>%
    rename(id = sector_name) %>%
    funky_heatmap(palettes = list(numerical_palette = "Reds"))

# CUSTOMIZED FUNKY HEAT MAP ----

# https://r-graph-gallery.com/38-rcolorbrewers-palettes_files/figure-html/thecode-1.png
palettes <- tribble(
    ~palette,             ~colours,
    "pal_greens",           grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "Greens"))(101),
    "pal_red_blue",           grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "RdBu"))(101),
    "pal_blue", grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "RdBu"))(101)[100:101]
)

column_info <- tribble(
    ~id,     ~group,         ~name,                      ~geom,        ~palette,    ~options,
    "id",    "Sector",       "",             "text",       NA,          list(hjust = 0, width = 6),
    "last_pct_change",  "Short Term",      "05:21 PM ET 06/02/2023",         "funkyrect",        "pal_red_blue", lst(),
    "one_day", "Short Term", "1 Day", "funkyrect", "pal_red_blue", lst(),
    "five_day", "Short Term", "5 Day", "funkyrect", "pal_red_blue", lst(),
    "one_month", "Short Term", "1 Month", "funkyrect", "pal_red_blue", lst(),

    "three_month", "Medium Term", "3 Month", "bar", "pal_greens", list(width = 2, legend = FALSE),
    "year_to_date", "Medium Term", "YTD", "bar", "pal_greens", list(width = 2, legend = FALSE),
    "one_year", "Medium Term", "1 Year", "bar", "pal_greens", list(width = 2, legend = FALSE),

    "three_year", "Long Term", "3 Year", "funkyrect", "pal_greens", lst(),
    "five_year", "Long Term", "5 Year", "funkyrect", "pal_greens", lst(),
    "ten_year", "Long Term", "10 Year", "funkyrect", "pal_greens", lst(),

)

column_groups <- tribble(
    ~group, ~palette, ~level1, ~level2,
    "Sector", "#333", "Sector", "",
    "Short Term", "pal_blue", "Short Term", "< 3 Months",
    "Medium Term", "pal_greens", "Medium Term", "< 1 year",
    "Long Term", "pal_greens", "Long Term", "3-10 Years"
)

row_info <- tribble(
    ~ "id", ~ "group",
    "Materials (.GSPM)", "Sectors",
    "Energy (.GSPE)", "Sectors",
    "Industrials (.GSPI)", "Sectors",
    "Consumer Discretionary (.GSPD)", "Sectors",
    "Financials (.GSPF)", "Sectors",
    "Real Estate (.GSPRE)", "Sectors",
    "Consumer Staples (.GSPS)", "Sectors",
    "Health Care (.GSPA)", "Sectors",
    "Utilities (.GSPU)", "Sectors",
    "Information Technology (.GSPT)", "Sectors",
    "Communication Services (.GSPL)", "Sectors",
    "S&P 500 ® Index (.SPX)", "Overall Market"
)

sector_performance_tbl %>%
    rename(id = sector_name) %>%
    funky_heatmap(
        column_info      = column_info,
        column_groups    = column_groups,
        row_info         = row_info,
        palettes         = palettes,
        col_annot_offset = 3.2,
    )

# LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


