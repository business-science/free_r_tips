# R TIPS ----
# TIP 041 | Easystats Performance | Check Model ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://mailchi.mp/business-science/r-tips-newsletter

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

# R FOR BUSINESS ANALYSIS COURSE (DS4B 101-R)
# - Learn modeling in Week 6 (K-Means Clustering & Supervised ML Regression)
#   https://university.business-science.io/p/ds4b-101-r-business-analysis-r

# 5-COURSE R-TRACK
# - Beginner to Expert in 6-months
#   https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series/



