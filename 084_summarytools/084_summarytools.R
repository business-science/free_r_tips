# BUSINESS SCIENCE R TIPS ----
# R-TIP 84 | SUMMARYTOOLS (ANALYZE DATA FASTER WITH R) ----

# LIBRARIES & DATA

library(summarytools)
library(tidyverse)

customer_churn_tbl <- read_csv("084_summarytools/data/customer_churn.csv")
customer_churn_tbl %>% glimpse()

# DF Summary ----
customer_churn_tbl %>%
    select(-customerID) %>%
    dfSummary(
        graph.col = TRUE,
        style="grid",
        graph.magnif = 0.75,
    ) %>%
    stview()


# Describe (Numeric Features) ----
customer_churn_tbl %>%
    descr() %>%
    stview()


# Freq (Categorical Features)
customer_churn_tbl %>%
    select(-customerID) %>%
    freq() %>%
    stview()
