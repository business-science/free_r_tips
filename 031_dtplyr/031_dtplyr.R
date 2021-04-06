# R TIPS ----
# TIP 031 | dtplyr: Data Table Backend ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

library(tidyverse)
library(dtplyr)

# Make a Lazy Data Table ----
mpg_dt <- lazy_dt(mpg)

# Summarize with Across ----
mpg_summary_dt <- mpg_dt %>%
    group_by(cyl) %>%
    summarise(across(
        .cols  = c(displ, cty:hwy),
        .fns   = list(mean, median),
        .names = "{.fn}_{.col}"
    ))

mpg_summary_dt

# Show the Data.Table Translation ----
mpg_summary_dt %>% show_query()

# Collect and Convert to Tibble
mpg_summary_dt %>% collect()

# LEARNING MORE ----
# - Learning Lab 13: Big Data Wrangling 4.6M Rows of Financial Data with data.table
# - Dplyr: Weeks 3 & 4 | DS4B 101-R Course (R for Business Analysis)
