# R TIPS ----
# TIP 037 | DataEditR: GUI for Data Wrangling in R ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

library(DataEditR)
library(tidyverse)
library(tidyquant)

# DATA ----
mpg


# 1.0 DATA EDITING ----

# 1.1 data_edit() ----

mpg_subset <- data_edit(
    x = mpg
)

# 1.2 RStudio Add-In ----

# Addins > Interactive Data Editor



# 2.0 LEARNING MORE -----

# R FOR BUSINESS ANALYSIS COURSE (DS4B 101-R)
# - Learn dplyr in Week 2 (Data Wrangling)
#   https://university.business-science.io/p/ds4b-101-r-business-analysis-r


mpg %>%

    select(manufacturer, model, cty, hwy, class) %>%
    pivot_longer(cols = c(cty, hwy)) %>%
    mutate(
        model = fct_reorder(
            str_glue("{manufacturer} {model}") %>% str_to_title(),
            value
        ),
        name = str_to_upper(name)
    ) %>%

    ggplot(aes(x = model, y = value, fill = class)) +
    geom_boxplot() +
    facet_grid(cols = vars(name), scales = "free_y") +
    coord_flip() +
    scale_fill_tq() +
    theme_tq() +
    labs(title = "Fuel Economy by Model", y = "MPG", x = "")

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/



