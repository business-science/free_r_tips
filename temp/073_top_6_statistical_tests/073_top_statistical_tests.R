

library(tidyverse)
library(infer)
library(broom)

set.seed(123) # For reproducibility of random data

# Sample data
dates <- seq(as.Date("2023-01-01"), by="day", length.out=10)
set.seed(123)
data <- data.frame(
    Group = rep(c("Control", "Treatment"), each = length(dates)),
    Sales = c(rnorm(length(dates), mean = 50, sd = 10), # Control group with some mean
              rnorm(length(dates), mean = 60, sd = 10)), # Treatment group with a higher mean
    Date = rep(dates, 2)
) %>%
    mutate(Group = as.factor(Group)) %>%
    as_tibble()

data %>%
    timetk::plot_time_series(Date, Sales, .color_var = Group, .smooth = F)


# Test for Difference in Means

data %>%
    t_test(
        Sales ~ Group,
        order = c("Treatment", "Control")
    )

lm(Sales ~ Group, data = data)

prop_test(gss,
          college ~ sex,
          order = c("female", "male"))
