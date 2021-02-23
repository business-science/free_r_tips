# R TIPS ----
# TIP 020 | Write SQL from R! 🤯 ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# SPECIAL SHOUT-OUT:
# - Emily Riederer's SQL dbplyr tutorial: https://emilyriederer.netlify.app/post/sql-generation/
# - LLPRO SQL for Data Science Series (Labs 21-23): https://university.business-science.io/p/learning-labs-pro

# LIBRARIES ----

library(DBI)
library(RSQLite)
library(tidyverse)

# 1.0 CONNECT TO SQL DB ----

con <- DBI::dbConnect(
    RSQLite::SQLite(),
    dbname = "020_write_sql_from_r/mpg.sqlite"
)

con

DBI::dbListTables(con)

# 2.0 WRITE SQL USING R ----
#   - Data Wrangling w/ Dplyr: Covered in DS4B 101-R Weeks 2 & 3
#   - Looking for more advanced SQL? Try Learning Labs PRO: SQL for Data Science 3-Part Series
#     https://university.business-science.io/p/learning-labs-pro

manufacturer_aggregations_tblcon <- tbl(con, "MPG") %>%
    group_by(manufacturer) %>%
    summarise(
        N = n(),
        across(.cols = c(displ, cty, hwy),
               .fns  = list(mean, median), na.rm = TRUE)
    )

manufacturer_aggregations_tblcon %>% show_query()

# 3.0 RUNNING THE TRANSFORMATION ON THE DATABASE ----

manufacturer_aggregations_tblcon %>% collect()

# 4.0 GETTING SQL AS TEXT ----
#   - Wrangling Text w/ stringr: Covered in DS4B 101-R Course, WEEK 3

manufacturer_aggregations_tblcon %>%
    show_query() %>%
    capture.output() %>%
    .[2:length(.)] %>%
    str_replace_all("`", "") %>%
    str_c(collapse = " ")


