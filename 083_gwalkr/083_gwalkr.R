# BUSINESS SCIENCE R TIPS ----
# R-TIP 83 | GWALKR (LIKE TABLEAU BUT COSTS $0) ----

# LIBRARIES & DATA

# install.packages("GWalkR")

library(GWalkR)
library(tidyverse)


# MPG DATA SET ----

mpg_tbl <- read_csv("083_gwalkr/data/mpg.csv")

GWalkR::gwalkr(mpg_tbl)


# TIME SERIES DATA SET ----

walmart_sales_tbl <- read_csv("083_gwalkr/data/walmart_sales.csv")

GWalkR::gwalkr(walmart_sales_tbl, dark = "dark")

