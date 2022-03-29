# BUSINESS SCIENCE R TIPS ----
# R-TIP 031 | dtplyr: Data Table Backend ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://learn.business-science.io/r-tips-newsletter

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

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


