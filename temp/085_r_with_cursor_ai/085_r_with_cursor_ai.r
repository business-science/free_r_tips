

# Load packages
library(tidyverse)

# 1.0 Locate data

customer_churn_tbl <- read_csv("085_r_with_cursor_ai/data/customer_churn.csv")

customer_churn_tbl %>% glimpse()


# 2.0 Explore data

library(summarytools)

customer_churn_tbl %>%
    select(-customerID) %>%
    dfSummary(
        graph.col = TRUE,
        style="grid",
        graph.magnif = 0.75,
    ) 





