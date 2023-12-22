


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

# * Main Summary Data ----
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

# * Label Data ----
sales_by_category_2_total_tbl <- sales_by_category2_y_tbl %>%
    group_by(category_2) %>%
    summarise(
        order_date = max(order_date),
        total_sales_all = sum(total_sales),
    ) %>%
    mutate(category_2 = fct_reorder2(category_2, order_date, total_sales_all)) %>%
    arrange(desc(category_2)) %>%
    mutate(
        midpoint = c(0, 0.5e6, 1e6, 2e6, 3e6, 4.7e6, 7.5e6, 1.1e7, 1.5e7)
    ) %>%
    mutate(
        text = str_glue("{category_2} {scales::dollar(total_sales_all, suffix = 'M', scale = 1/1e6)}")
    )

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
    geom_stream(type = "ridge", bw = 1.1, extra_span = 0.10) +
    labs(x = "", y = "") +

    # Theme
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq(base_family = "Josefin_Sans") +

    # Advanced Theming
    coord_cartesian(clip = "off") +
    theme(
        legend.position = "none",
        axis.line.x = element_line(linewidth = .75),
        panel.grid = element_blank(),
        axis.text.y = element_blank(),
        panel.border = element_blank(),
        plot.margin = margin(20,160,20,20),
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

    # Y-Axis Labels (Legend)
    geom_text(
        aes(x = (order_date + days(30)) , y = midpoint, label = text),
        hjust = 0,
        family = "Josefin_Sans",
        data = sales_by_category_2_total_tbl
    )





