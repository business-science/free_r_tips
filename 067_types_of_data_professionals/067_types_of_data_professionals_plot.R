# BUSINESS SCIENCE R TIPS ----
# R-TIP 067 | Types of data professionals visualization (radar plot) ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# LIBRARIES ----

library(tidyverse)
library(patchwork)
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
    expand_limits(y = c(0, 12)) +
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
        legend = NULL,
        x = NULL,
        y = NULL
    ) +
    theme(
        plot.title = element_text(
            hjust = 0.5,
            margin = margin(t = 20, b = 20),
            size = 25,
            face = "bold",
            family = "serif"
        ),
        strip.text = element_text(
            size = 15,
            face = "bold",
            margin = margin(t = 5, b = 5)
        ),
        legend.position = "none",
        axis.text.y = element_blank(),
        axis.text.x = element_text(vjust = -1),
        panel.spacing = unit(50, "points")
    )


# 4.0 LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


