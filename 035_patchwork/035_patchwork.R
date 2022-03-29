# BUSINESS SCIENCE R TIPS ----
# R-TIP 035 | patchwork: combine ggplots into 1 ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://learn.business-science.io/r-tips-newsletter

# LIBRARIES ----

library(patchwork)
library(ggridges)
library(ggrepel)
library(maps)
library(tidyverse)
library(lubridate)


# 1.0 Data Transformation -----

txhousing_tbl <- txhousing %>%
    mutate(date = lubridate::make_date(year, month))


# 2.0 Make Subplots ----

# 2.1 Time Series ----

gg_tx_timeseries <- txhousing_tbl %>%
    ggplot(aes(date, median, group = city)) +
    geom_line(color = "gray20", alpha = 0.25) +
    geom_smooth(
        aes(group = NULL),
        method = "loess",
        span = 0.1,
        se = FALSE,
        size = 2.5,
        color = "black"
    ) +
    theme_minimal() +
    scale_y_continuous(labels = scales::dollar_format()) +
    labs(y = "", x = "", title = "Median Home Price Over Time")
gg_tx_timeseries

# 2.2 Top Cities Ridgeline Plot ----

gg_tx_ridge <- txhousing_tbl %>%
    drop_na() %>%
    mutate(city = factor(city) %>% fct_reorder(median) %>% fct_rev()) %>%
    filter(as.numeric(city) %in% (1:10)) %>%

    ggplot(aes(x = median, y = fct_rev(city))) +
    geom_density_ridges(
        color = "#18BC9C",
        fill  = "gray10",
        alpha = 0.75,
        size  = 1
    ) +
    scale_x_continuous(labels = scales::dollar_format()) +
    theme_minimal() +
    labs(x = "Median Home Price", y = "", title = "Top 10 Cities by Median Home Price")

gg_tx_ridge

# 2.3 Texas Map ----

texas_housing_tbl <- txhousing_tbl %>%
    group_by(city) %>%
    summarise(median = median(median, na.rm = T)) %>%
    ungroup() %>%
    mutate(city = str_to_lower(city))

texas_cities_tbl <- us.cities %>%
    filter(country.etc == "TX") %>%
    mutate(name = name %>%
               str_sub(end = nchar(name) - 3) %>%
               str_to_lower() %>%
               str_trim()
    ) %>%
    left_join(texas_housing_tbl, by = c("name" = "city"))

texas_outline_tbl <- map_data("state", region = "texas") %>% as_tibble()

gg_tx_map <- texas_cities_tbl %>%
    drop_na() %>%
    ggplot(aes(x = long, y = lat, size = median)) +
    geom_polygon(
        data  = texas_outline_tbl,
        aes(x = long, y = lat, group = group, size = NULL),
        color = "black",
        size = 1.5,
        fill = "#18bc9c"
    ) +
    geom_point() +
    geom_text_repel(aes(label = str_to_title(name)), max.overlaps = 5) +
    # scale_color_viridis_c() +
    coord_map() +
    theme_void() +
    labs(title = "Median Home Prices by City", x = "", y = "") +
    theme(legend.position = "none")

gg_tx_map

# 3.0 Patchwork ----

gg_tx_map + (gg_tx_timeseries / gg_tx_ridge) +
    plot_layout(widths = c(3,2), tag_level = "new") +
    plot_annotation(
        title      = "Texas Real-Estate Statistics",
        subtitle   = "The untold secrets of prime-real estate in the Lonestar State.\n",
        tag_levels = "A",
        tag_prefix = "Fig. ",
        tag_suffix = ":"
    ) &
    theme(plot.tag.position = c(0, 1),
          plot.tag = element_text(size = 8, hjust = 0, vjust = 0))


# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


