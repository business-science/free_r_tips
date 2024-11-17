# BUSINESS SCIENCE R TIPS ----
# R-TIP 91 | INTRODUCING TIDYPLOTS ----

# GOAL: Show a new publication-ready plotting tool in R

# Libraries
library(tidyplots)

# ENGERY (TIME SERIES EXAMPLES) ----

energy %>%
    tidyplot(x = year, y = power, color = energy_source) %>%
    add_barstack_absolute() %>%
    adjust_size(width = NA, height = NA) %>%
    adjust_font(fontsize = 12) %>%
    add_title("Energy Production Over Time")


energy %>%
    tidyplot(x = year, y = power, color = energy_source) %>%
    add_areastack_absolute() %>%
    adjust_size(width = NA, height = NA) %>%
    adjust_font(fontsize = 12) %>%
    add_title("Energy Production Over Time")

energy %>%
    tidyplot(color = energy_type) %>%
    add_pie() %>%
    adjust_size(width = NA, height = NA) %>%
    # adjust_font(fontsize = 12) %>%
    add_title("Energy Production")

energy_week %>%
    tidyplot(date, power, color = energy_source) %>%
    add_areastack_absolute() %>%
    adjust_size(width = NA, height = NA) %>%
    adjust_font(fontsize = 12) %>%
    add_title("Energy By Week")


# MONTHLY EXPENSE ----

spendings %>%
    tidyplot(x = date, y = amount, color = category) %>%
    add_barstack_absolute() %>%
    adjust_size(width = NA, height = NA) %>%
    adjust_font(fontsize = 12) %>%
    add_title("Monthly Expenses")

spendings %>%
    tidyplot(y = category, x = amount) %>%
    add_sum_bar() %>%
    adjust_size(width = NA, height = NA) %>%
    adjust_font(fontsize = 12) %>%
    sort_y_axis_labels() %>%
    add_title("Monthly Expense Categories")



# TIME COURSE ----

time_course %>%
    tidyplot(x = day, y = score, color = treatment) %>%
    add_mean_line() %>%
    add_mean_dot() %>%
    add_sem_errorbar(width = 1) %>%
    adjust_size(width = NA, height = NA) %>%
    adjust_font(fontsize = 12) %>%
    add_title("Uncertainty bars")

time_course %>%
    tidyplot(x = day, y = score, color = treatment) %>%
    add_mean_line() %>%
    add_mean_dot() %>%
    add_sem_ribbon() %>%
    adjust_size(width = NA, height = NA) %>%
    adjust_font(fontsize = 12) %>%
    add_title("Uncertainty")
