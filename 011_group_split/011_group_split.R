# R TIPS ----
# TIP 011 | Must-Know Tidyverse Features: Group Split ----
# - map()
# - broom + linear regression
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----
library(tidyquant)
library(tidyverse)
library(broom)

# devtools::install_github("rstudio/fontawesome")
library(gt)
library(fontawesome)
library(htmltools)

# DATA ----
mpg

# 1.0 GROUP SPLIT ----
# - Turns a grouped data frame into an list of data frames (iterable)
# - Iteration & functions - Covered in Week 5 of DS4B 101-R

# Group Split
mpg %>%
    mutate(manufacturer = as_factor(manufacturer)) %>%
    group_by(manufacturer) %>%
    group_split()

# We can now iterate with map()
mpg %>%
    mutate(manufacturer = as_factor(manufacturer)) %>%
    group_by(manufacturer) %>%
    group_split() %>%

    map(.f = function(df) {
        lm(hwy ~ cty, data = df)
    })

# 2.0 POWER OF BROOM ----
# - Tidy up our linear regression metrics with glance()
# - Modeling & Machine Learning - Covered in Week 6 of DS4B 101-R Course

hwy_vs_city_tbl <- mpg %>%
    mutate(manufacturer = as_factor(manufacturer)) %>%
    group_by(manufacturer) %>%
    group_split() %>%

    map_dfr(.f = function(df) {
        lm(hwy ~ cty, data = df) %>%
            glance() %>%
            add_column(manufacturer = unique(df$manufacturer), .before = 1)
    })

# 3.0 SUPER AWESOME TABLE WITH GT PACKAGE ----

# Source: https://themockup.blog/posts/2020-10-31-embedding-custom-features-in-gt-tables/
rating_stars <- function(rating, max_rating = 5) {
    rounded_rating <- floor(rating + 0.5)  # always round up
    stars <- lapply(seq_len(max_rating), function(i) {
        if (i <= rounded_rating) {
            fontawesome::fa("star", fill= "orange")
        } else {
            fontawesome::fa("star", fill= "grey")
        }
    })
    label <- sprintf("%s out of %s", rating, max_rating)
    div_out <- div(title = label, "aria-label" = label, role = "img", stars)

    as.character(div_out) %>%
        gt::html()
}

hwy_vs_city_tbl %>%
    select(manufacturer, nobs, r.squared, adj.r.squared, p.value) %>%
    mutate(manufacturer = str_to_title(manufacturer)) %>%
    mutate(rating = cut_number(r.squared, n = 5) %>% as.numeric()) %>%
    mutate(rating = map(rating, rating_stars)) %>%
    arrange(desc(r.squared)) %>%
    gt() %>%
    tab_header(title = gt::md("__Highway vs City Fuel Mileage__")) %>%
    tab_spanner(
        label = gt::html("<small>Relationship Strength (hwy ~ cty)</small>"),
        columns = vars(r.squared, adj.r.squared, p.value)
    ) %>%
    fmt_number(columns = vars(r.squared, adj.r.squared)) %>%
    fmt_number(columns = vars(p.value), decimals = 3) %>%
    tab_style(
        style = cell_text(size = px(12)),
        locations = cells_body(
            columns = vars(r.squared, adj.r.squared, p.value))
    ) %>%
    cols_label(
        manufacturer = gt::md("__MFG__"),
        nobs = gt::md("__#__"),
        r.squared = gt::html(glue::glue("<strong>R-Squared ", fontawesome::fa("arrow-down", fill = "orange"), "</strong>")),
        adj.r.squared = gt::md("__R-Squared (Adj)__"),
        p.value = gt::md("__P-Value__"),
        rating  = gt::md("__Rating__")
    )
