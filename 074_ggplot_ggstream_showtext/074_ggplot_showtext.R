# BUSINESS SCIENCE R TIPS ----
# R-TIP 74 | Advanced ggplot2 visualizations: ggstream and showtext ----

# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# 👉 Shoutout:
#  https://r-graph-gallery.com/web-stacked-area-chart-inline-labels.html

# 👉 R-Track Masterclass:
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


# Libraries ----
library(tidyverse)
library(timetk)
library(ggstream)  # smooth geom area shapes
library(showtext)  # load custom fonts
library(tidyquant) # tidyquant color theme

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
    labs(title= "Cannondale Bicycle Sales", x = "Date", y = "Total Sales") +
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq()



# Step 4: Better Fonts -----
# * Make sure to run the "Custom Fonts" code above

sales_by_category2_y_tbl %>%
    ggplot(aes(order_date, total_sales, fill = category_2, color = category_2, label=category_2)) +
    geom_stream(type = "ridge", bw = 1.1, extra_span = 0.10) +

    # Theme
    labs(title= "Cannondale Bicycle Sales", x = "Date", y = "Total Sales") +
    scale_color_tq() +
    scale_fill_tq() +
    theme_tq(
        base_family = "Josefin_Sans"
    )



# BONUS: Step 5: Advanced Annotation and Theming ----

# * Y-Label Data ----
y_label_tbl <- sales_by_category2_y_tbl %>%
    group_by(category_2) %>%
    summarise(
        order_date = max(order_date),
        total_sales_all = sum(total_sales),
    ) %>%
    mutate(category_2 = fct_reorder2(category_2, order_date, total_sales_all)) %>%
    arrange(desc(category_2)) %>%
    mutate(
        midpoint = c(0, 0.5e6, 1e6, 2e6, 3e6, 4.9e6, 7.5e6, 1.1e7, 1.5e7)
    ) %>%
    mutate(
        y_text = str_glue("{category_2} {scales::dollar(total_sales_all, suffix = 'M', scale = 1/1e6)}")
    )

# * X-Label Data ----

x_label_tbl <- sales_by_category2_y_tbl %>%
    group_by(order_date) %>%
    summarize(
        total_sales_all = sum(total_sales),
    ) %>%
    mutate(points = c(12492885, 13513075, 16030775, 15424085, 18971510)) %>%
    mutate(x_text = scales::dollar(total_sales_all))

# * Publication-Quality Visualization ----

sales_by_category2_y_tbl %>%
    ggplot(aes(order_date, total_sales)) +
    geom_stream(aes(fill = category_2, color = category_2), type = "ridge", bw = 1.1, extra_span = 0.10) +
    labs(x = "", y = "") +

    # Theme
    # labs(title= "Cannondale Bicycle Sales", x = "Date", y = "Total Sales") +
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
        plot.margin = margin(0,160,20,20),
    ) +

    # Advanced Annotations
    expand_limits(y = 2.4e7) +

    # Title
    annotate(
        "text",
        label = "Cannondale Bicycle\nSales",
        x = parse_date2("2011-01-01") %>% as_datetime(),
        y = 2.3e7,
        size = 12,
        hjust = 0,
        vjust = 1,
        family = "Josefin_Sans",
        fontface = "bold"
    ) +

    # Y-Axis Labels (Legend)
    geom_text(
        aes(x = (order_date + days(30)) , y = midpoint, label = y_text, color = category_2),
        hjust = 0,
        family = "Josefin_Sans",
        fontface = "bold",
        size = 3,
        data = y_label_tbl
    ) +

    # X-Axis Labels (Points)
    geom_point(
        aes(x = order_date, y = points),
        color = "black",
        fill = "black",
        data = x_label_tbl
    ) +
    geom_segment(
        aes(xend = order_date, x = order_date, yend = 0, y = points),
        color = "black",
        size = 0.75,
        data = x_label_tbl
    ) +
    geom_text(
        aes(x = order_date, y = points, label = x_text),
        # hjust = 0,
        nudge_y = 5e5,
        family = "Josefin_Sans",
        fontface = "bold",
        size = 3,
        data = x_label_tbl
    )





