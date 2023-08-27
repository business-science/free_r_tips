# BUSINESS SCIENCE R TIPS ----
# R-TIP 067 | Types of data professionals visualization (radar plot) ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# LIBRARIES & DATA----

library(tidyverse)
library(readxl)

types_of_data_professionals_tbl <- read_excel("067_types_of_data_professionals/data/types_of_data_professionals.xlsx")
types_of_data_professionals_tbl

# 1.0 DATA PREPARATION ----
data_prep_tbl <- types_of_data_professionals_tbl %>%
    rename(type = 1) %>%
    pivot_longer(
        cols = -type
    ) %>%
    mutate(
        type = as_factor(type),
        name = as_factor(name)
    )

data_prep_tbl

# 2.0 BASIC RADAR PLOT ----

# The trick
coord_radar <- function (theta = "x", start = 0, direction = 1, clip = "on") {
    theta <- match.arg(theta, c("x", "y"))
    r <- if (theta == "x") "y" else "x"
    ggproto("CordRadar", CoordPolar, theta = theta, r = r, start = start,
            direction = sign(direction), clip = clip,
            is_linear = function(coord) TRUE)
}


basic_radar_plot <- data_prep_tbl %>%
    ggplot(aes(name, value, group = type)) +
    geom_polygon(aes(fill = type, color = type), alpha = 0.25) +
    geom_point(aes(color = type)) +
    scale_y_continuous(limits = c(-1, 13), breaks = c(0, 2.5, 5, 7.5, 10)) +
    coord_radar(start = -0.3, clip = "off") +
    facet_wrap(~ type)

basic_radar_plot

# 3.0 DRESS UP THE RADAR PLOT ----
basic_radar_plot  +
    theme_minimal() +
    scale_fill_manual(values = c("#588f3a", "#E7B800", "#00AFBB", "#FC4E07")) +
    scale_color_manual(values = c("#588f3a", "#E7B800", "#00AFBB", "#FC4E07")) +
    labs(
        title = "Types of Data Professionals",
        subtitle = "Which are you?",
        legend = NULL,
        x = NULL,
        y = NULL
    ) +
    theme(
        plot.title = element_text(
            hjust = 0.5,
            margin = margin(t = 5, b = 20),
            size = 28,
            face = "bold",
            family = "serif"
        ),
        plot.subtitle = element_text(
            color = "dodgerblue",
            hjust = 0.5,
            margin = margin(t = 0, b = 20),
            size = 20,
            face = "bold",

        ),
        strip.text = element_text(
            size = 18,
            face = "bold",
            margin = margin(t = 5, b = 5)
        ),
        legend.position = "none",
        axis.text.y = element_blank(),
        axis.text.x = element_text(
            vjust = -1,
            size = 8
        ),
        panel.spacing = unit(50, "points"),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_line(colour = c(rep("#ebebeb", 5), NA))
    )


# 4.0 LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


