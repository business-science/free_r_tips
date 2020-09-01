# R TIPS ----
# MODULE: FOR LOOPS ----
# PROJECT SETUP

library(tidyverse)

mpg %>%
    group_by(manufacturer) %>%
    group_split() %>%
    walk(function(x) {
        write_csv(x, path = str_c("./data/", unique(x$manufacturer), ".csv"))
    })
