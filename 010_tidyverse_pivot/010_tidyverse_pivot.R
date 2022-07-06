# R TIPS ----
# TIP 010 | Must-Know Tidyverse Features: Pivoting Data ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://learn.business-science.io/r-tips-newsletter

# LIBRARIES ----
library(tidyquant)
library(tidyverse)

# DATA ----
mpg

# PIVOTING DATA ----

# 1.0 Pivot Wider ----
# - Reshaping to wide format

mpg_pivot_table_1 <- mpg %>%
    group_by(manufacturer) %>%
    count(class, name = "n") %>%
    ungroup() %>%
    pivot_wider(
        names_from  = class,
        values_from = n,
        values_fill = 0
    )

# 2.0 Pivot Table ----

# - Making Summary "Pivot Tables"
mpg_pivot_table_2 <- mpg %>%
    pivot_table(
        .columns = class,
        .rows    = manufacturer,
        .values  = ~ n(),
        fill_na  = 0
    )

# - Using lists to capture complex objects
mpg %>%
    pivot_table(
        .rows    = class,
        .values  = ~ list(lm(hwy ~ displ + cyl - 1))
    )


# 3.0 Pivot Longer ----
# - Long format best for visualizations

mpg_long_summary_table <- mpg_pivot_table_1 %>%
    pivot_longer(
        cols      = compact:subcompact,
        names_to  = "class",
        values_to = "value"
    )

mpg_long_summary_table %>%
    ggplot(aes(class, manufacturer, fill = value)) +
    geom_tile() +
    geom_label(aes(label = value), fill = "white") +
    scale_fill_viridis_c() +
    theme_minimal() +
    labs(title = "Class by Auto Manufacturer")

# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass



