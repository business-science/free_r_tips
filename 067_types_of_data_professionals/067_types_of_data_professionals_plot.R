# BUSINESS SCIENCE R TIPS ----
# R-TIP 067 | Types of data professionals plot  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://github.com/ricardo-bion/ggradar

# LIBRARIES ----

# devtools::install_github("ricardo-bion/ggradar", dependencies = TRUE)

library(tidyverse)
library(ggradar)
library(patchwork)
library(tidyquant)
library(readxl)


types_of_data_professionals_tbl <- read_excel("067_types_of_data_professionals/data/types_of_data_professionals.xlsx")

data_formatted_tbl <- types_of_data_professionals_tbl %>%
    rename(group = 1) %>%
    mutate_if(is.numeric, scales::rescale) %>%
    mutate(group = as_factor(group))


# BASIC RADAR PLOT
data_formatted_tbl %>%
    ggradar()


data_formatted_tbl %>%
    ggradar(
        # group.colours = palette_light() %>% unname(),
        group.colours = c("#588f3a", "#c9ad49", "#3d7ea3", "#d6502a"),
        fill          = TRUE,
        fill.alpha    = 0.25,
        axis.label.size = 3,
        grid.label.size = 3,
        group.line.width = 0.75,
        group.point.size = 1.5

    ) +
    facet_wrap(~ group) +
    theme_void() +
    theme(
        strip.text = element_text(
            size   = 18,
            colour = "black",
            margin = margin(t = 5, b = 5)
        ),
        # strip.background = element_rect(fill = "#2C3E50"),
        legend.position = "none",
        plot.margin = margin(10, 10, 10, 10)
    )
