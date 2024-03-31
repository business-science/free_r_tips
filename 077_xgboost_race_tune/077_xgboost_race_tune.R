# BUSINESS SCIENCE R TIPS ----
# R-TIP 77 | XGBoost: My 2-Step Hyperparamter Tuning Process ----

# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# 👉 Do you want to become the data science expert for your organization?
#   HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

# 👉 5-Course R-Track Program (My Program to become a data scientist):
#  https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series?el=newsletter

# LIBRARIES and DATA ----
library(tidymodels)
library(finetune)
library(tidyverse)
library(janitor)

slice <- dplyr::slice

churn_tbl <- read_csv("076_xgboost_hyper_tune/churn.csv") %>%
    clean_names()

churn_tbl %>% glimpse()

churn_tbl <- churn_tbl %>%
    select(-customer_id) %>%
    filter(!is.na(monthly_charges))

# MODEL AND PREPORCESSOR SPEC ----

xgb_spec_stage_1 <- boost_tree(
    mode   = "classification",
    engine = "xgboost",
    learn_rate     = tune(),
    tree_depth     = tune(),
    loss_reduction = tune(),
    stop_iter      = tune()
)

rec_spec <- recipe(churn ~ ., churn_tbl) %>%
    step_dummy(all_nominal_predictors(), one_hot = TRUE)

rec_spec %>% prep() %>% juice() %>% glimpse()

# * Create a workflow ----
wflw_xgb_stage_1 <- workflow() %>%
    add_model(xgb_spec_stage_1) %>%
    add_recipe(rec_spec)

# RACING METHOD ----

# STAGE 1: TUNE LEARNING RATE ----

# * Define the tuning grid ----
set.seed(123)
grid_stage_1 <- grid_random(
    learn_rate(),
    tree_depth(),
    loss_reduction(),
    stop_iter(),
    size = 20
)

# * Tune the model ----
set.seed(123)
cv_folds <- vfold_cv(churn_tbl, v = 5)
tune_stage_1 <- tune_race_anova(
    wflw_xgb_stage_1,
    resamples = cv_folds,
    grid      = grid_stage_1,
    metrics   = metric_set(roc_auc),
    control   = control_race(verbose = TRUE)
)

# tune_stage_1 %>% write_rds("077_xgboost_race_tune/tune_results/tune_results_1.rds")

tune_stage_1 %>% collect_metrics() %>% arrange(-mean)

# ROC AUC (RACING METHOD): 0.831

# ROC AUC (MATT'S 2 STAGE METHOD FROM R-TIP 076): 0.839

# CONCLUSIONS: ----
# - RACING METHODS IMPROVE SPEED VS CONVENTIONAL GRID AS ONLY 12 COMBINATIONS WHERE TESTED VS 20
# - MATT'S 2-STEP METHOD (R-TIP 076) OF TUNING LEARNING RATE FIRST AND THEN
#    TUNING ADDITIONAL PARAMS HAD A HIGHER AUC 0.839 VS 0.831
# - I HAD TO INCREASE THE GRID SIZE TO 50 TO GET A MARGINALLY BETTER AUC 0.841

