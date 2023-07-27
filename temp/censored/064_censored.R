

# LIBRARIES & DATA ----

library(tidymodels)
library(censored)
library(tidyverse)
library(janitor)


churn_raw_tbl <- read_csv("064_censored/data/churn_data.csv") %>%
    janitor::clean_names() %>%
    rowid_to_column("row_id")

churn_raw_tbl %>% glimpse()

# 1.0 PREPROCESSING FOR CHURN SURVIVAL ANALYSIS -----

recipe_survival <- recipe(churn ~ ., churn_raw_tbl) %>%
    step_rm(row_id, customer_id) %>%
    step_impute_mean(all_numeric_predictors()) %>%
    step_mutate(
        churn = ifelse(churn == "Yes", 2, 1),
        tenure = tenure + 1
    )

churn_processed_tbl <- recipe_survival %>% prep() %>% juice()

churn_processed_tbl %>% glimpse()


# 3.0 BASIC SURVIVAL RATE ----

# * GLMNET ----

model_proportional_hazards <- proportional_hazards(penalty = 0.1) %>%
    set_mode("censored regression") %>%
    set_engine("glmnet")

model_proportional_hazards

fit_proportional_hazards <- model_proportional_hazards %>%
    fit(Surv(tenure, churn) ~ ., data = churn_processed_tbl)

fit_proportional_hazards %>%
    predict(churn_processed_tbl)

pred_proportional_hazards <- fit_proportional_hazards %>%
    predict(churn_processed_tbl, type = "survival", eval_time = c(3,6,12,24,48,72)) %>%
    unnest(.pred)

pred_proportional_hazards %>%
    ggplot(aes())




model_survival_mboost <- boost_tree() %>%
    set_mode("censored regression") %>%
    set_engine("mboost")

model_survival_mboost

model_survival_mboost %>%
    fit(Surv(tenure, churn) ~ ., data = churn_tbl)


model_survival_rf <- rand_forest() %>%
    set_mode("censored regression") %>%
    set_engine("partykit")

model_survival_rf

model_survival_rf %>%
    fit(Surv(tenure, churn) ~ ., data = churn_tbl)




# OLD ----

workflow() %>%
    # add_recipe(recipe_survival) %>%
    add_formula(Surv(tenure, churn) ~ . ) %>%
    add_model(model_rf) %>%
    fit(data = churn_raw_tbl %>% drop_na())


# survival_rate_tbl <- churn_raw_tbl %>%
#     select(row_id, churn, tenure) %>%
#     arrange(tenure) %>%
#     mutate(churn_yes = ifelse(churn == "Yes", 1, 0)) %>%
#     mutate(cummulative_churn = cumsum(churn_yes)) %>%
#     mutate(churn_rate = cummulative_churn / sum(churn_yes)) %>%
#     mutate(survival_rate = 1 - churn_rate) %>%
#     select(row_id, tenure, survival_rate)
#
# survival_rate_tbl %>%
#     ggplot(aes(tenure, survival_rate)) +
#     geom_step() +
#     labs(title = "Survival Rate")
