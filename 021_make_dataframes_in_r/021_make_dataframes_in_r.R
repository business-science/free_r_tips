# R TIPS ----
# TIP 021 | Create a Data Frame in R (4 ways)! ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----

library(readxl)
library(writexl)
library(plotly)
library(tidyverse)

# 1. MAKE A DATA FRAME FROM SCRATCH ----

df <- tibble(
    a = 1:10
)

class(df)

is.data.frame(df)


# 2. FROM DATA SOURCES ----
#  - Data Import is covered in Data Wrangling (Week 2 & 3) of DS4B 101-R
#  - Line Plots are covered in Data Visualization (Week 4) of DS4B 101-R

interest_rate_tbl <- readxl::read_xlsx(
    "021_make_dataframes_in_r/interest_rate.xlsx",
    sheet = 1)

interest_rate_tbl

g <- interest_rate_tbl %>%
    ggplot(aes(date, interest_rate)) +
    geom_line() +
    geom_hline(yintercept = 0, color = "gray50")

ggplotly(g)


# 3. FROM OTHER DATA STRUCTURES ----

moneyball_list <- list(
    user_name = c("Bill James",
                  "Billy Beane",
                  "Peter Brand",
                  "Art Howe"),
    email     = c(
        "bill.james@gmail.com",
        "billy.beane@gmail.com",
        "peter.brand@harvard.edu",
        "art.howe@hotmail.com"
    ),
    tags      = list(
        list("writer", "baseball", "stats"),
        list("GM", "baseball"),
        list("analyst", "baseball", "stats"),
        list("coach", "baseball")
    )
)

moneyball_list

moneyball_list %>% as_tibble()


# 4. ENFRAME & DEFRAME ----

?enframe

enframe(c("blah", "blah", "blah"), name = "name", value = "contents") %>% deframe()

enframe(moneyball_list) %>%
    pivot_wider(
        names_from  = name,
        values_from = value
    ) %>%
    unnest(user_name:tags) %>%
    unnest(tags) %>%
    unnest(tags)


# BONUS: HOW I MADE THE INTEREST RATE DATA ----

interest_rate_tbl <- tibble(
    date          = timetk::tk_make_timeseries("2010", length_out = 12, by = "year"),
    interest_rate = (seq(12, 3, length.out = 12) * (sin(1:12) + 2)) / 12
)
interest_rate_tbl %>% writexl::write_xlsx("021_make_dataframes_in_r/interest_rate.xlsx")

# QUOTE ----
# "THE BEST INVESTMENT IS AN INVESTMENT IN YOURSELF."
# ~ Warren Buffet


