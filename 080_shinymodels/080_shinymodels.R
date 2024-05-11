# BUSINESS SCIENCE R TIPS ----
# R-TIP 80 | Shinymodels ----

# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# 👉 Do you want to become the data science expert for your organization?
#   HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

library(shinymodels)
library(tidymodels)
library(tidyverse)

# DATA ----

marketing_campaign_tbl <- read_csv("080_shinymodels/data/marketing_campaign.csv")

marketing_campaign_tbl %>% glimpse()

# 1.0 DATA PREPARATION ----

data_prep_tbl <- marketing_campaign_tbl %>%

    # Remove NA values
    drop_na() %>%

    # Feature: Customer Age - max customer date
    mutate(Dt_Customer = dmy(Dt_Customer)) %>%
    mutate(Dt_Customer_Age = -1*(Dt_Customer - min(Dt_Customer) ) / ddays(1) ) %>%
    select(-Dt_Customer) %>%

    # Spent = Sum(Mnt...)
    mutate(Spent = rowSums(across(starts_with("Mnt")))) %>%

    # Remove unnecessary features
    select(-Z_CostContact, -Z_Revenue)

data_prep_tbl %>% glimpse()

# 2.0 RECIPE ----

recipe_xgb <- recipe(Response ~ ., data = data_prep_tbl) %>%
    step_dummy(all_nominal_predictors(), one_hot = TRUE) %>%
    step_rm("ID")
    # step_mutate(Response = as.factor(Response))

recipe_xgb %>% prep() %>% juice() %>% glimpse()


# 3.0 MODEL ----

wflw_xgb <- workflow() %>%
    add_model(boost_tree("regression") %>% set_engine("xgboost")) %>%
    add_recipe(recipe_xgb)

# 4.0 RESAMPLES ----

set.seed(123)
resampled_xgb <- wflw_xgb %>%
    fit_resamples(
        resamples = vfold_cv(data_prep_tbl, v = 10),
        control = control_resamples(save_pred = TRUE)
    )

# 5.0 SHINYMODELS ----

shinymodels::explore(resampled_xgb)
