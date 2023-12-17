# BUSINESS SCIENCE R TIPS ----
# R-TIP 73 | Introduction to A/B Testing ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Questions:
# 1. Does Adspend increase bookings?
# 2. By how much? Was there a Return on Adspend (ROAS)?

# Libraries ----

library(infer)
library(tidyverse)
library(timetk)
library(plotly)

# Data ----

hotel_bookings_raw_tbl <- read_csv("073_ab_testing_infer/data/hotel_bookings_geo_experiment.csv")
hotel_bookings_raw_tbl

# 1.0 Exploratory Data Analysis ----

PRE_INTERVENTION  <- c("2015-01-05", "2015-02-15") %>% as_date()
POST_INTERVENTION <- c("2015-02-16", "2015-03-15") %>% as_date()

# * Data Exploration ----

bookings_by_assignment_over_time_tbl <- hotel_bookings_raw_tbl %>%
    group_by(assignment) %>%
    summarize_by_time(
        bookings = sum(bookings),
        cost  = sum(cost),
        .by   = "day"
    ) %>%
    ungroup()

bookings_by_assignment_over_time_tbl %>%
    group_by(assignment) %>%
    plot_time_series(
        date, bookings,
        .color_var = assignment,
        .interactive = FALSE,
        .title = "Adspend Effect"
    ) +
    annotate(
        "rect",
        xmin = as_date("2015-02-16"),
        xmax = as_date("2015-03-15"),
        ymin = -Inf,
        ymax = Inf,
        alpha = 0.2,
        fill  = "blue"
    )



# 2.0 A/B Test: Difference in Means ----
# - We are comparing 2 continuous groups, so use a 2-sided T-test to
#   calculate the difference in means between the 2 populations.

# * Split data into pre and experiment ----

pre_intervention_only_tbl <- hotel_bookings_raw_tbl %>%
    filter_by_time(.start_date = PRE_INTERVENTION[1], .end_date = PRE_INTERVENTION[2])

experiment_only_tbl <- hotel_bookings_raw_tbl %>%
    filter_by_time(.start_date = POST_INTERVENTION[1], .end_date = POST_INTERVENTION[2])

# * 2-sample t-test ----
diff_in_means_data_tbl <- experiment_only_tbl %>%
    select(assignment, bookings)

test_statistic_tbl <- diff_in_means_data_tbl %>%
    t_test(
        bookings ~ assignment,
        order = c("treatment", "control"),
        alternative = "two-sided"
    )

test_statistic_tbl

# * Linear Regression -----
# - If you're doing a 2-sample t-test, this is actually the same thing
# - More importantly, linear regression can help with more complex problems
#   that contain multiple regressors

lm(bookings ~ assignment, data = diff_in_means_data_tbl) %>% summary()

# * Average Treatment Effect (ATE) ----

ate = test_statistic_tbl$estimate
ate

diff_in_means_data_tbl %>% count(assignment) %>% pull(n) %>% pluck(2)

# N * ATE
bookings_increase = 1393 * 96
bookings_increase

# N * ATE / COST
ROAS = (1393 * 96) / 50000
ROAS

# 3.0 LEARN MORE RIGHT NOW! ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


