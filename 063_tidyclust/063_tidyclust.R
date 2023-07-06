# BUSINESS SCIENCE R TIPS ----
# R-TIP 063 | Introduction to K-Means Clustering in R (tidyclust)  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter
#
# **** -----

# GOAL: Improve Your Ability to Cluster Data with K-means

# LIBRARIES ----

library(tidymodels)
library(tidyclust)
library(tidyverse) # May need to import library(lubridate)
library(tidyquant)
library(plotly)

# DATA ----

marketing_campaign_tbl <- read_csv("063_tidyclust/data/marketing_campaign.csv")

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
    select(-Z_CostContact, -Z_Revenue, -Response)

data_prep_tbl %>% glimpse()

# 2.0 RECIPE ----

recipe_kmeans <- recipe(~ ., data = data_prep_tbl) %>%
    step_dummy(all_nominal_predictors(), one_hot = TRUE) %>%
    step_normalize(all_numeric_predictors()) %>%
    step_rm("ID")

recipe_kmeans %>% prep() %>% juice() %>% glimpse()

# 3.0 K-MEANS MODEL ----

model_kmeans <- k_means(num_clusters = 4) %>%
    set_engine("stats")

set.seed(123)
wflw_fit_kmeans <- workflow() %>%
    add_model(model_kmeans) %>%
    add_recipe(recipe_kmeans) %>%
    fit(data_prep_tbl)

# 4.0 PREDICT NEW DATA ----

wflw_fit_kmeans %>% predict(data_prep_tbl)

extract_cluster_assignment(wflw_fit_kmeans)

extract_centroids(wflw_fit_kmeans)

# BONUS: VISUALIZE CLUSTERS ----

g <- data_prep_tbl %>%
    bind_cols(extract_cluster_assignment(wflw_fit_kmeans), .) %>%
    ggplot(aes(Spent, Income)) +
    geom_point(
        aes(fill = .cluster),
        shape = 21,
        alpha = 0.3,
        size  = 5
    ) +
    geom_smooth(color = "blue", se = FALSE) +
    scale_x_continuous(labels = scales::dollar_format()) +
    scale_y_continuous(
        labels = scales::dollar_format(),
        limits = c(0, 200000)
    ) +
    labs(title = "Customer Clusters: Spent vs Income") +
    scale_fill_tq() +
    theme_tq()

ggplotly(g)

# BASIC INTRODUCTION....
# LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass



