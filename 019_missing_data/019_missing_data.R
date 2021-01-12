# R TIPS ----
# TIP 019 | Missing Values ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter


# LIBRARIES ----

library(visdat)
library(naniar)
library(simputation)
library(tidyverse)

air_quality_tbl <- airquality %>% as_tibble()
air_quality_tbl


# 1.0 MISSING DATA VISUALIZATIONS ----
# - Visualization, Covered in DS4B 101-R, Week 4

# * vis_dat() -----

air_quality_tbl %>% vis_dat()

# * vis_miss() ----

air_quality_tbl %>% vis_miss()


# * gg_miss_upset() ----

air_quality_tbl %>% gg_miss_upset()

# * geom_miss_point() ----

air_quality_tbl %>%
    ggplot(aes(x = Solar.R, y = Ozone)) +
    geom_miss_point()


# 2.0 IMPUTATION ----

# * Linear Imputation - impute_lm() ----
# - Data Wrangling - Covered in DS4B 101-R, Week 2&3

air_quality_tbl %>%

    # Label if Ozone is missing
    add_label_missings(Ozone) %>%

    # Imputation - Linear Regression
    mutate(Ozone = as.double(Ozone)) %>%
    impute_lm(Ozone ~ Temp + Wind) %>%

    # Visualize
    ggplot(aes(Solar.R, Ozone, color = any_missing)) +
    geom_point()

# * Random Forest - impute_rf() ----

air_quality_tbl %>%

    # Label if Ozone is missing
    add_label_missings(Ozone) %>%

    # Imputation - Ozone
    mutate(Ozone = as.double(Ozone)) %>%
    impute_rf(Ozone ~ Temp + Wind) %>%

    # Imputation - Solar.R
    mutate(Solar.R = as.double(Solar.R)) %>%
    impute_rf(Solar.R ~ Temp + Wind) %>%

    # Visualize
    ggplot(aes(Solar.R, Ozone, color = any_missing)) +
    geom_point()
