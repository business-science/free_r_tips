# R TIPS ----
# TIP 026 | Assess Data Quality with skimr ---
#
# 👉 For Weekly R-Tips, Sign Up Here: https://learn.business-science.io/r-tips-newsletter

# skimr: designed for data quality

# LIBRARIES ----

library(skimr)
library(tidyverse)

# DATA ----

starwars

# SKIMMING! ----
# - Gives a super-helpful diagnostic report
# - Great for understanding missing data
# - Great for quickly understanding your data composition (numeric, date, factor, etc)

# * Starwars / Missing Data & Lists ----
starwars %>% skim()

starwars %>% filter(is.na(birth_year))

# * Storms / Missing Data & Categorical ----
storms %>% skim()

# * Economics / Time Series (Date) ----
economics %>% skim()

# * Economics Long / Grouped Data ----
economics_long %>% group_by(variable) %>% skim()


# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass





