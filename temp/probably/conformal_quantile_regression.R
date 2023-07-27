library(workflows)
library(dplyr)
library(parsnip)
library(rsample)
library(tune)
library(modeldata)
library(probably)

set.seed(2)
sim_train <- sim_regression(500)
sim_cal   <- sim_regression(200)
sim_new   <- sim_regression(  5) %>% select(-outcome)

# We'll use a neural network model
mlp_spec <-
    mlp(hidden_units = 5, penalty = 0.01) %>%
    set_mode("regression")

mlp_wflow <-
    workflow() %>%
    add_model(mlp_spec) %>%
    add_formula(outcome ~ .)

mlp_fit <- fit(mlp_wflow, data = sim_train)

mlp_int <- int_conformal_quantile(
    object     = mlp_fit,
    train_data = sim_train,
    cal_data   = sim_cal,
    level      = 0.90
)
mlp_int

predict(mlp_int, sim_new)

modeltime::modeltime_table(mlp_int)
