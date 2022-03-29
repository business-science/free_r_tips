# BUSINESS SCIENCE R TIPS ----
# R-TIP 047| ggplot2: Customer Heat Map ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# LIBRARIES ----

library(tidyverse)
library(tidyquant)

sales_by_customer_tbl <- read_rds("047_customer_heatmap/sales_by_customer.rds")

sales_by_customer_tbl

# 1.0 HEATMAP DATA WRANGLE ----

prop_sales_by_customer_tbl <- sales_by_customer_tbl %>%
    group_by(bikeshop_name) %>%
    mutate(prop = quantity / sum(quantity)) %>%
    ungroup() %>%

    # AVOID THIS ROOKIE MISTAKE - DON'T FORGET TO SORT BY TOP PRODUCT ----

    select(-quantity) %>%
    pivot_wider(
        id_cols     = bikeshop_name,
        names_from  = product_category,
        values_from = prop
    ) %>%
    arrange(-`Elite Road`) %>%
    mutate(bikeshop_name = fct_reorder(bikeshop_name, `Elite Road`)) %>%
    pivot_longer(
        cols      = -bikeshop_name,
        names_to  = "product_category",
        values_to = "prop"
    )


# 2.0 HEATMAP VISUALIZATION ----

prop_sales_by_customer_tbl %>%

    ggplot(aes(product_category, bikeshop_name)) +

    # Geometries
    geom_tile(aes(fill = prop)) +
    geom_text(aes(label = scales::percent(prop, accuracy = 1)),
              size = 3) +


    # Formatting
    scale_fill_gradient(low = "white", high = palette_light()[1]) +
    labs(
        title = "Heatmap of Customer Purchasing Habits",
        subtitle = "Used to investigate Customer Similarity",
        x = "Bike Type (Product Category)",
        y = "Bikeshop (Customer)"
    ) +

    theme_tq() +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none",
        plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(face = "bold.italic")
    )

# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://www.business-science.io/rtrack_freewebinar.html

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/

