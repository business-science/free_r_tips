# BUSINESS SCIENCE R TIPS ----
# R-TIP 033 | corrmorrant: ggplot2 extension for correlation matricies ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://learn.business-science.io/r-tips-newsletter

# LIBRARIES ----

# remotes::install_github("r-link/corrmorant")

library(corrmorant)
library(tidyverse)

# QUICK CORRELATIONS ----
corrmorant(mpg)

corrmorant(mpg, style = "dark")

corrmorant(mpg, style = "dark") +
    theme_dark() +
    labs(title = "Correlations")

# GGPLOT2 API ----

# Customize Diagonal, Upper Tri, Lower Tri
ggcorrm(data = mpg) +
    lotri(geom_point(alpha = 0.5)) +
    lotri(geom_smooth()) +
    utri_heatmap() +
    utri_corrtext() +
    dia_names(y_pos = 0.15, size = 3) +
    dia_histogram(lower = 0.3, fill = "grey80", color = 1) +
    scale_fill_corr() +
    labs(title = "Correlation Plot")

# Within Groups
corfun <- function(x, y)  round(cor(x, y,method = "pearson", use = "pairwise.complete.obs"), 2)

ggcorrm(
        mapping = aes(col = cyl, fill = cyl),
        data    = mpg %>% mutate(cyl = factor(cyl)),
        bg_dia  = "grey30"
    ) +
    lotri(geom_point(alpha = 0.5)) +
    lotri(geom_smooth(se=F, method = "lm")) +
    utri_funtext(fun = corfun, size = 6) +
    dia_names(y_pos = 0.15, size = 3) +
    dia_density(lower = 0.3, fill = "grey60", color = 1) +
    theme_dark() +
    scale_color_viridis_d() +
    scale_fill_viridis_d() +
    labs(title = "Correlation Plot")

# LEARNING MORE ----

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

