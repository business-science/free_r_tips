# R TIPS ----
# TIP 009 | Must-Know Tidyverse Features: Summarise + Across ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----
library(tidyverse)

# DATA ----
mpg %>% View()

# SUMMARIZE W/ ACROSS ----
# - Group By + Summarize: Super common summarization pattern
# - Summarize + Across: Scale your summarizations:
#    - Multiple columns
#    - Multiple Summary Functions (e.g. mean, sd)

# 1.0 BASIC USAGE ----

# * AVERAGE CITY FUEL CONSUMPTION BY VEHICLE CLASS ----
mpg %>%
    group_by(class) %>%
    summarise(
        across(cty, .fns = mean),
        .groups = "drop"
    )

# * AVERAGE & STDEV CITY FUEL CONSUMPTION BY VEHICLE CLASS
mpg %>%
    group_by(class) %>%
    summarise(
        across(cty, .fns = list(mean = mean, stdev = sd)), .groups = "drop"
    )

# * AVERAGE & STDEV CITY + HWY FUEL CONSUMPTION BY VEHICLE CLASS
mpg %>%
    group_by(class) %>%
    summarise(
        across(c(cty, hwy), .fns = list(mean = mean, stdev = sd)), .groups = "drop"
    )

# 2.0 ADVANCED ----

# * CUSTOMIZE NAMING SCHEME ----
mpg %>%
    group_by(class) %>%
    summarise(
        across(
            c(cty, hwy),
            .fns = list(mean = mean, stdev = sd),
            .names = "{.fn} {.col} Consumption"
        ),
        .groups = "drop"
    ) %>%
    rename_with(.fn = str_to_upper)

# * COMPLEX FUNCTIONS ----
mpg %>%
    group_by(class) %>%
    summarise(
        across(
            c(cty, hwy),
            .fns = list(
                "mean"     = ~ mean(.x),
                "range lo" = ~ (mean(.x) - 2*sd(.x)),
                "range hi" = ~ (mean(.x) + 2*sd(.x))
            ),
            .names = "{.fn} {.col}"
        ),
        .groups = "drop"
    ) %>%
    rename_with(.fn = str_to_upper)
