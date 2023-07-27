library(tidymodels)
library(probably)
library(future)

tidymodels_prefer()

## Make a fitted workflow from some simulated data:
set.seed(121)
train_dat <- sim_regression(200)
new_dat   <- sim_regression(  5) %>% select(-outcome)

lm_fit <-
    workflow() %>%
    add_model(linear_reg()) %>%
    add_formula(outcome ~ .) %>%
    fit(data = train_dat)

# Create the object to be used to make prediction intervals
lm_conform <- int_conformal_full(lm_fit, train_dat)

predict(lm_conform, new_dat)
