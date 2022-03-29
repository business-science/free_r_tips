# BUSINESS SCIENCE R TIPS ----
# R-TIP 034 | mmtable2: ggplot2 syntax for tables ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://learn.business-science.io/r-tips-newsletter

# LIBRARIES ----

# remotes::install_github("ianmoran11/mmtable2")

library(mmtable2)
library(gt)
library(tidyverse)

mpg


# 1.0 Data Transformation -----

data_wrangled <- mpg %>%
    group_by(manufacturer, cyl) %>%
    summarise(across(.cols = c(cty, hwy), .fns = mean)) %>%
    ungroup() %>%
    pivot_longer(
        cols = c(cty, hwy),
        names_to = "fuel_economy_type",
        values_to = "fuel_economy"
    )

data_wrangled


# 2.0 Table Main ----
main_table <- data_wrangled %>%
    mutate(fuel_economy = round(fuel_economy, 1)) %>%

    mmtable(cells = fuel_economy, table_name = "Fuel Economy") +

    # Specify Headers
    header_top(manufacturer) +
    header_left(cyl) +
    header_left_top(fuel_economy_type) +


    # Specify formatting
    header_format(manufacturer, list(cell_text(transform = "capitalize"))) +
    header_format(fuel_economy_type, list(cell_text(transform = "uppercase"))) +
    table_format(
        locations = list(
            cells_body(rows = c(2, 6))
        ),
        style     = list(
            cell_borders(sides = "top", color = "grey")
        )
    )

# 3.0 Modify with GT Table ----
main_table %>%
    gt::tab_header(
        title = "Fuel Economy by Car Manufacturer",
        subtitle = "Audi, VW, and Honda are leaders in Fuel Economy"
    )

# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

