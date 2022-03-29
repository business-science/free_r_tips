# BUSINESS SCIENCE R TIPS ----
# R-TIP 049 | ModelStudio: Interactive Studio for Explanatory Model Analysis  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://modelstudio.drwhy.ai/index.html

# INSTALLATION ----
# install.packages("modelStudio")


# LIBRARIES ----

library(modelStudio)
library(DALEX)
library(tidyverse)
library(tidymodels)

# DATA ----

data_tbl <- mpg %>%
    select(hwy, manufacturer:drv, fl, class)

# MODEL ----

fit_xgboost <- boost_tree(learn_rate = 0.3) %>%
    set_mode("regression") %>%
    set_engine("xgboost") %>%
    fit(hwy ~ ., data = data_tbl)

fit_xgboost

# EXPLAINER ----

explainer <- DALEX::explain(
    model = fit_xgboost,
    data  = data_tbl,
    y     = data_tbl$hwy,
    label = "XGBoost"
)

# MODEL STUDIO ----

modelStudio::modelStudio(explainer)

# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

