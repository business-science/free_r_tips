# R TIPS ----
# MODULE: FOR LOOPS ----
# Reading Multiple Files

library(tidyverse)
library(fs)

file_paths <- fs::dir_ls("r_tips_001_for_loop/data")
file_paths

# 1.0 FOR LOOP ----

file_contents <- list()

for (i in seq_along(file_paths)) {
    file_contents[[i]] <- read_csv(
        file = file_paths[[i]]
    )
}

file_contents <- set_names(file_contents, file_paths)


# 2.0 PURRR MAP ----

file_paths %>%
    map(function (path) {
        read_csv(path)
    })



