# BUSINESS SCIENCE R TIPS ----
# R-TIP 060 | Healthy R for Health Care Data  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Congrats to my student Steven Sanderson! 👏
# Documentation: https://www.spsanderson.com/healthyR/

# TABLE OF CONTENTS: ----
# 1. READMITANCE RATE CHARTS
# 2. AVERAGE LENGTHS OF STAY PLOTS
# 3. BONUS: GARTNER MAGIC CHART

# Libraries ----
library(healthyR)
library(tidyverse)

# Data ----
healthcare_tbl <- read_csv("060_healthyR/healthydata.csv")

healthcare_tbl %>% glimpse()

healthcare_tbl %>%
    count(mrn, sort = TRUE)

# 1.0 READMITTANCE RATES ----

healthcare_tbl %>%
    ts_readmit_rate_plt(
        .date_col    = visit_start_date_time,
        .value_col   = readmit_flag,
        .by_grouping = "week",
        .interactive = FALSE
    )

# 2.0 AVERAGE LENGTH OF STAY PLOTS ----

healthcare_tbl %>%
    filter(ip_op_flag == "I") %>%
    select(visit_end_date_time, length_of_stay) %>%
    summarise_by_time(
        .date_var = visit_end_date_time,
        .by       = "day",
        visits    = mean(length_of_stay, na.rm = TRUE)
    ) %>%
    filter_by_time(
        .date_var     = visit_end_date_time,
        .start_date = "2012",
        .end_date   = "2019"
    ) %>%
    set_names("Date","Values") %>%
    ts_alos_plt(
        Date, Values,
        .by          = "month",
        .interactive = TRUE
    )

# 3.0 BONUS: GARTNER MAGIC CHARTS ----
# - The 4 Boxes Gartner uses to measure everything
# - Compares 2 Continuous Variables

mpg %>%
    select(hwy, displ) %>%
    rename(x = displ, y = hwy) %>%
    scale() %>%
    as_tibble() %>%
    gartner_magic_chart_plt(
        .x_col = x,
        .y_col = y,
        .point_size_col = y,
        .x_lab = "Displacement",
        .y_lab = "Highway Fuel Economy",
        .plt_title = "Highway vs Displacement",
        .tr_lbl = "Sports Cars",
        .tl_lbl = "Compact & Subcompacts",
        .bl_lbl = "Minivans",
        .br_lbl = "SUVs & Pickups"
    )

# LEARNING MORE ----
# - Has your data science progress has stopped?

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

