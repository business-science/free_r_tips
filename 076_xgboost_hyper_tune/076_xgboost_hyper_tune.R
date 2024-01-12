# BUSINESS SCIENCE R TIPS ----
# R-TIP 76 | XGBoost: My 2-Step Hyperparamter Tuning Process ----

# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# 👉 Do you want to become the data science expert for your organization?
#   HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

# 👉 5-Course R-Track Program (My Program to become a data scientist):
#  https://university.business-science.io/p/5-course-bundle-machine-learning-web-apps-time-series?el=newsletter

# LIBRARIES and DATA ----
library(tidymodels)
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
    learn_rate = tune()
)

rec_spec <- recipe(churn ~ ., churn_tbl) %>%
    step_dummy(all_nominal_predictors(), one_hot = TRUE)

rec_spec %>% prep() %>% juice() %>% glimpse()

# 2 STAGE HYPERPARAMETER TUNING PROCESS ----

# STAGE 1: TUNE LEARNING RATE ----

# * Define the stage 1 tuning grid ----
set.seed(123)
grid_stage_1 <- grid_random(
    learn_rate(),
    size = 10
)

# * Create a workflow ----
wflw_xgb_stage_1 <- workflow() %>%
    add_model(xgb_spec_stage_1) %>%
    add_recipe(rec_spec)

# * Tune the model ----
set.seed(123)
cv_folds <- vfold_cv(churn_tbl, v = 5)
tune_stage_1 <- tune_grid(
    wflw_xgb_stage_1,
    resamples = cv_folds,
    grid      = grid_stage_1,
    metrics   = metric_set(roc_auc),
    control   = control_grid(verbose = TRUE)
)

tune_stage_1 %>% collect_metrics() %>% arrange(-mean)

# ROC AUC: 0.839

# STAGE 2: HOLD LEARN RATE CONSTANT / TUNE OTHER PARAMS ----

# * Get Best Params Stage 1 ----
best_params_stage_1 <- tune_stage_1 %>%
    collect_metrics() %>%
    arrange(-mean) %>%
    slice(1)

# * Model Spec Stage 2: Hold LR constant ----
xgb_spec_stage_2 <- xgb_spec_stage_1 %>%
    set_args(
        learn_rate     = best_params_stage_1$learn_rate,
        tree_depth     = tune(),
        loss_reduction = tune(),
        stop_iter      = tune()
    )

wflw_xgb_stage_2 <- wflw_xgb_stage_1 %>%
    update_model(xgb_spec_stage_2)

# * Define Stage 2 grid ----
set.seed(123)
grid_stage_2 <- grid_random(
    tree_depth(),
    loss_reduction(),
    stop_iter(),
    size = 10
)

# * Tune stage 2 -----
tune_stage_2 <- tune_grid(
    wflw_xgb_stage_2,
    resamples = cv_folds,
    grid      = grid_stage_2,
    metrics   = metric_set(roc_auc),
    control   = control_grid(verbose = TRUE)
)

tune_stage_2 %>% collect_metrics() %>% arrange(-mean)

# BEST ROC STAGE 2: 0.839 (NO IMPROVEMENT)

# FINAL MODEL ----

# * Select Best Params ----
best_params_stage_2 <- tune_stage_2 %>%
    collect_metrics() %>%
    arrange(-mean) %>%
    slice(1)

# * Update Best Parameters Args ----
xgb_spec_final <- xgb_spec_stage_2 %>%
    set_args(
        tree_depth     = best_params_stage_2$tree_depth,
        loss_reduction = best_params_stage_2$loss_reduction,
        stop_iter      = best_params_stage_2$stop_iter,
    )

# * Fit the Final Model ----
wflw_final <- wflw_xgb_stage_2 %>%
    update_model(xgb_spec_final) %>%
    fit(churn_tbl)

# * Make Predictions ----
bind_cols(
    wflw_final %>% predict(churn_tbl),
    wflw_final %>% predict(churn_tbl, type = "prob"),
    churn_tbl
)

