# BUSINESS SCIENCE R TIPS ----
# R-TIP 041 | Easystats Performance | Check Model ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# REFERENCE:
# https://easystats.github.io/performance/

# LIBRARIES ----

# install.packages("performance", dependencies = TRUE)
# Installs all dependencies

library(tidyverse)
library(performance)


# DATA ----

mpg

# 1.0 PERFORMANCE ----

model_lm <- lm(hwy ~ displ + class, data = mpg)

model_lm

check_model(model_lm)


# 2.0 TIDYMODELS ----

library(tidymodels)

# * Linear Regression ----
model_lm_tidy <- linear_reg() %>%
    set_engine("lm") %>%
    fit(hwy ~ displ + class, data = mpg)

check_model(model_lm_tidy)


# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/



