# BUSINESS SCIENCE R TIPS ----
# R-TIP 059 | Sherlock (For Process Visualizations & Manufacturing Analytics)  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Congrats to my student Gabor Szabo! 👏
# Documentation: https://gaboraszabo.github.io/sherlock/

# TABLE OF CONTENTS: ----
# 1. MULTIVARIATE PLOTS
# 2. PARETO CHARTS
# 3. PROCESS BEHAVIOR CHARTS

# Libraries ----
library(sherlock)
library(tidyverse)

# Data ----
mpg

# 1.0 MULTIVARIATE PLOTS ----
# - Uncover changes between states

# * No Means ----
mpg %>%
    draw_multivari_plot(
        response   = hwy,
        factor_1   = year,
        factor_2   = class
    )

# * Show change (using means) ----
mpg %>%
    draw_multivari_plot(
        response   = hwy,
        factor_1   = year,
        factor_2   = class,
        plot_means = T
    ) +
    labs(title = "MPG vs Model Year")

# 2.0 PARETO CHART ----
# - Useful for analyzing 80/20 principle for frequency
mpg %>%
    group_by(class) %>%
    summarise(
        n = n()
    ) %>%
    draw_pareto_chart(
        cat_var                 = class,
        continuous_var          = n,
        highlight_first_n_items = 2,
        lump_last_n_items       = 2,
    )

# 3.0 PROCESS BEHAVIOR CHART ----
# - Identify outliers (common for detecting manufacturing defects and scrap rates)
mpg %>%
    draw_process_behavior_chart(
        y_var = hwy,
        interactive = TRUE
    )

mpg %>%
    draw_process_behavior_chart(
        y_var        = hwy,
        grouping_var = class,
        interactive  = TRUE
    )

mpg %>% slice(213)
mpg %>% slice(60)


# LEARNING MORE ----
# - Has your data science progress has stopped?

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

