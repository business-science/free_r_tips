# R TIPS ----
# TIP 008 | Must-Know Tidyverse Features: Relocate ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----
library(tidyverse)

# DATA ----
mpg

# SELECT VS RELOCATE ----

# - Select is like filter() for columns
mpg %>%
    select(model, manufacturer, class, year)

# - Relocate is like arrange() for columns
mpg  %>%
    relocate(model, manufacturer, class, year)

?relocate

# 1.0 RELOCATE BY COLUMN NAME ----
# - Move single column by position

mpg %>%
    relocate(manufacturer, .after = class)

?last_col

mpg %>%
    relocate(manufacturer, .after = last_col())

mpg %>%
    relocate(manufacturer, .after = last_col(offset = 1))


# 2.0 RELOCATE BY DATA TYPE ----
# - Move multiple columns by data type

mpg %>%
    relocate(where(is.numeric))

mpg %>%
    relocate(where(is.character))

mpg %>%
    relocate(where(is.character), .after = last_col())


# 3.0 RELOCATE WITH TIDYSELECT ----

?contains

mpg %>%
    relocate(starts_with("m"), .before = year)
