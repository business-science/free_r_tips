


# 1.0 LIBRARIES & DATA ----
library(h2o)
library(tidyverse)

# Initialize the H2O cluster
h2o.init()

# Data
data <- h2o.importFile(path = "073_h2o_automl/data/bank.csv")


# 2.0 H2O AUTOML ----

# Define the response column, and the predictor columns
response <- "y" # This column indicates if the client subscribed to a term deposit
predictors <- setdiff(names(data), response)

# Run AutoML for a maximum of 300 seconds (5 minutes)
automl_models <- h2o.automl(
    y = response,
    x = predictors,
    training_frame = data,
    max_runtime_secs = 45
)

# 3.0 LEADERBOARD ----
automl_models@leaderboard %>%
    as_tibble()


# 4.0 SHUTDOWN H2O ----
h2o.shutdown(prompt = FALSE)
