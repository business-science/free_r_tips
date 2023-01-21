# BUSINESS SCIENCE R TIPS ----
# R-TIP 057 | shinyML  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://github.com/JeanBertinR/shinyML

# LIBRARIES ----

library(shinyML)
library(h2o)
library(tidyverse)

# DATA ----

churn_data_tbl <- read_csv("057_shinyml/data/churn.csv")

churn_data_tbl %>% glimpse()

# SHINY ML ----

shinyML_classification(
    data      = churn_data_tbl,
    y         = "Churn",
    framework = "h2o"
)

# BONUS: H2O LEADERBOARD + BEST MODELS ----

h2o.init()

# * STEP 1: Get the model IDs that were just created
#   - Note: Remove DeepLearning Models (Error out in the leaderboard)
model_ids <- h2o.list_models() %>%
    str_subset(pattern = "^(?!(DeepLearning))")

model_ids

# * STEP 2: Make a list of models
models <- model_ids %>% map(h2o.getModel)
models %>% View()

# * STEP 3: Make the leaderboard
models %>%
    h2o.make_leaderboard(
        sort_metric = "AUTO"
    )

# LEARNING MORE ----
# - Want to learn faster - get my 10 secrets to becoming a data scientist?

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


