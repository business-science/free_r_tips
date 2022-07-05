# BUSINESS SCIENCE R TIPS ----
# R-TIP 052 | Explainable AI Reports with modelDown ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://modeloriented.github.io/modelDown/

# LIBRARIES ----

library(tidyverse)  # Core
library(janitor)    # Clean names
library(tidymodels) # Modeling
library(DALEX)      # Explainer
library(modelDown)  # Explainable AI Report


# DATA ----

customer_churn_tbl <- read_csv("051_survival_plots/data/customer_churn.csv") %>%
    clean_names() %>%
    mutate_if(is.character, as_factor)

customer_churn_tbl

# MODEL ----

recipe_spec <- recipe(churn ~ ., data = customer_churn_tbl) %>%
    step_rm(customer_id) %>%
    step_dummy(all_nominal_predictors(), one_hot = TRUE)

recipe_spec %>% prep() %>% bake(customer_churn_tbl)

model_spec <- rand_forest(
        mode = "classification",
        mtry = 4
    ) %>%
    set_engine(engine = "randomForest")

wflw_fit_rf <- workflow() %>%
    add_recipe(recipe_spec) %>%
    add_model(model_spec) %>%
    fit(customer_churn_tbl)

wflw_fit_rf %>% predict(customer_churn_tbl)

wflw_fit_rf %>%
    predict(customer_churn_tbl, type = "prob") %>%
    pull(2)

# EXPLAINABLE AI REPORT ----

pred_func <- function(model, newdata) {
    predict(model, newdata, type = "prob") %>% pull(2)
}

pred_func(wflw_fit_rf, head(customer_churn_tbl))

explain_rf <- explain(
    model            = wflw_fit_rf,
    data             = customer_churn_tbl %>% select(-churn),
    y                = as.numeric(customer_churn_tbl$churn),
    predict_function = pred_func,
    label            = "Random Forest"
)

modelDown::modelDown(
    explain_rf,
    modules       = c("variable_importance", "variable_response"),
    output_folder = "052_modeldown/output"
)


# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

