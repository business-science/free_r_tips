# R TIPS ----
# TIP 031 | dtplyr: Data Table Backend ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

library(tidyverse)
library(dtplyr)
library(tidyquant)

# 1.0 DATA TABLE ----

# * Make a Lazy Data Table ----
mpg_dt <- lazy_dt(mpg)

# * Summarize with Across ----
mpg_summary_dt <- mpg_dt %>%
    group_by(manufacturer, cyl) %>%
    summarise(across(
        .cols  = c(displ, cty:hwy),
        .fns   = list(mean, median),
        .names = "{.fn}_{.col}"
    )) %>%
    ungroup()

mpg_summary_dt

# * Show the Data.Table Translation ----
mpg_summary_dt %>% show_query()

# * Collect and Convert to Tibble
mpg_summary_tbl <- mpg_summary_dt %>% collect()

# 2.0 GGPLOT ----

# * City Fuel Mileage Heat Map ----
mpg_summary_tbl %>%
    ggplot(aes(manufacturer, factor(cyl), fill = mean_cty)) +
    geom_tile() +
    geom_text(aes(label = round(mean_cty, 1)), size = 3) +
    scale_fill_viridis_c(direction = 1) +
    labs(title = "Average City Fuel Mileage by Engine Size (Cylinders)",
         x = "Manufacturer", y = "Engine Size (Cylinders",
         fill = "Average City Mileage") +
    coord_flip() +
    tidyquant::theme_tq()


# LEARNING MORE ----
# - Learning Lab 13: Big Data Wrangling 4.6M Rows of Financial Data with data.table
#    https://university.business-science.io/p/learning-labs-pro
# - Dplyr: Weeks 3 & 4 | DS4B 101-R Course (R for Business Analysis)
#    https://university.business-science.io/p/ds4b-101-r-business-analysis-r
