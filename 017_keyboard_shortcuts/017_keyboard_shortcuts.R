# R TIPS ----
# TIP 017 | Keyboard Shortcuts ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter


# LIBRARIES ----

library(tidyverse)
library(timetk)

# KEYBOARD SHORTCUTS ----

# 1. Commenting/Uncommenting, [Ctrl + Shift + C] ----
# - I use this all the time!!

library(modeltime)


# 2. The pipe, [Ctrl + Shift + M] ----
# - Data wrangling (dplyr), DS4B 101-R Course (Weeks 2 & 3)
# - Time Series (timetk, modeltime), DS4B 203-R Course

m4_monthly %>%
    group_by(id) %>%
    plot_time_series(date, value)

# 3. Assignment, [Alt + -] ----
# - I use this ALL THE TIME
# - Functional Programming & Iteration (purrr), DS4B 101-R (Week 5)

a <- 1

add2 <- function(x, y) {
    x + y
}

add2(3, 4)

# 4. Select Multiple Lines, [Ctrl + Alt + Up/Down] ----

library(modeltime)
library(modeltime.ensemble)
library(modeltime.gluonts)

# 5. Find in Files, [Ctrl + Shift + F] ----
# - SUPER POWERFUL
# - I use this a lot for R Package Development or in searching complex projects

# Let's find all files that use the "ggplot" function


# 6. Get All Keyboard Shortcuts,  [Alt + Shift + K] ----
# - Get all the keyboard shortcuts!

