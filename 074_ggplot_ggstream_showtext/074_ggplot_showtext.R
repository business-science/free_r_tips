


# Libraries ----
library(tidyverse)
library(timetk)
library(ggstream) # smooth geom area shapes
library(showtext) # load custom fonts
library(tidyquant) # tq theme

# Custom Fonts ----
# * Run this to enable showtext fonts used in this tutorial:
font_add_google(name = "Josefin Sans", family = "Josefin_Sans")
showtext_auto()

# Data ----
# * ONE OF THE BUSINESS DATASETS FROM THE R-TRACK PROGRAM
transactions_raw_tbl <- read_csv("074_ggplot_ggstream_showtext/data/bike_orderlines.csv")

transactions_raw_tbl %>% glimpse()

# Data Wrangling ----

sales_by_category2_y_tbl <- transactions_raw_tbl %>%
    mutate(total_sales = quantity * price) %>%
    group_by(category_2) %>%
    summarise_by_time(
        .by = "year",
        total_sales = sum(total_sales)
    ) %>%
    ungroup() %>%
    mutate(category_2 = fct_reorder2(category_2, order_date, total_sales)) %>%
    arrange(category_2)

sales_by_category_2_total_tbl <- sales_by_category2_y_tbl %>%
    group_by(category_2) %>%
    summarise(
        order_date = max(order_date),
        total_sales_all = sum(total_sales),
        total_sales_1y = last(total_sales)
    ) %>%
    mutate(category_2 = fct_reorder2(category_2, order_date, total_sales_all)) %>%
    arrange(desc(category_2)) %>%
    mutate(total_sales_lag1 = lag(total_sales_1y, n = 1)) %>%
    mutate(total_sales_lag1 = replace_na(total_sales_lag1, 0)) %>%
    mutate(midpoint = (total_sales_1y + total_sales_lag1) / 2)

# ADVANCED VISUALIZATION TUTORIAL ----

# Step 1: Basic Stacked Area ----

sales_by_category2_y_tbl %>%
    ggplot(aes(order_date, total_sales, fill = category_2, color = category_2, label=category_2)) +
    geom_area()

# Step 2: Geom Stream ----

sales_by_category2_y_tbl %>%
    ggplot(aes(order_date, total_sales, fill = category_2, color = category_2, label=category_2)) +
    geom_stream(type = "ridge", bw = 1.1, extra_span = 0.10)

# Step 3: Improve the appearance -----

sales_by_category2_y_tbl %>%
    ggplot(aes(order_date, total_sales, fill = category_2, color = category_2, label=category_2)) +
    geom_stream(type = "ridge", bw = 1.1, extra_span = 0.10) +

    # Theme
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq()

# Step 4: Better Fonts -----
# * Make sure to run the "Custom Fonts" code above

sales_by_category2_y_tbl %>%
    ggplot(aes(order_date, total_sales, fill = category_2, color = category_2, label=category_2)) +
    geom_stream(type = "ridge", bw = 1.1, extra_span = 0.10) +

    # Theme
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq(base_family = "Josefin_Sans")

# Step 5: Advanced Annotation ----

sales_by_category2_y_tbl %>%
    ggplot(aes(order_date, total_sales, fill = category_2, color = category_2, label=category_2)) +
    geom_area() +
    # geom_stream(type = "ridge", bw = 1.1, extra_span = 0.10) +
    labs(x = "", y = "") +

    # Theme
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq(base_family = "Josefin_Sans") +

    # Advanced Theming
    theme(
        legend.position = "none",
        axis.line.x = element_line(linewidth = .75),
        panel.grid = element_blank(),
        axis.text.y = element_blank(),
        panel.border = element_blank(),
        plot.margin = margin(20,120,20,20),
    ) +

    # Advanced Annotations
    expand_limits(y = 2.3e7) +

    # Title
    annotate(
        "text",
        label = "Cannondale Bicycle\nSales",
        x = parse_date2("2011-01-01") %>% as_datetime(),
        y = 2.1e7,
        size = 13,
        hjust = 0,
        vjust = 1,
        family = "Josefin_Sans"
    ) +

    #
    geom_text(
        aes(x = (order_date + days(30)) , y = midpoint),
        label = "test",
        hjust = 0,
        data = sales_by_category_2_total_tbl
    )



