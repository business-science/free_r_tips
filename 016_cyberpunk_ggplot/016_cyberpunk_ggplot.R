# R TIPS ----
# TIP 016 | Custom Time Series Plots (Bonus Cyberpunk ggplot Theme) ----
# - Plotting time series
# - Customize ggplot
# - Use a cyberpunk-style plot
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# Use Case:
# - Use customized interactive time series plots in Shiny Web Apps!

# LIBRARIES ----
library(plotly)
library(tidyverse)
library(timetk)


# 1.0 DATA ----
walmart_sales_weekly

# 2.0 QUICK VISUALIZATION ----
# * Using timetk::plot_time_series()
# - timetk visualization is covered in DS4B 203-R Week 2

g1 <- walmart_sales_weekly %>%
    group_by(id) %>%
    plot_time_series(
        .date_var    = Date,
        .value       = Weekly_Sales,
        .color_var   = id,
        .smooth      = TRUE,
        .facet_ncol  = 3,
        .interactive = FALSE
    )

g1

# 3.0 FROM SCRATCH ----
# - ggplot2 is covered in DS4B 101-R Week 4

walmart_sales_weekly %>%
    ggplot(aes(Date, Weekly_Sales, color = id, group = id)) +
    geom_line() +
    geom_smooth(
        aes(Date, Weekly_Sales),
        inherit.aes = FALSE,
        se = FALSE
    ) +
    facet_wrap(
        facets = ~ id,
        scales = "free_y",
        ncol   = 2
    ) +
    theme_minimal() +
    theme(legend.position = "bottom")

# 4.0 CYBERPUNK STYLE ----
# - Customizing ggplots is covered in DS4B 101-R Week 4
# - Credit: https://github.com/R-CoderDotCom/cyberpunk/blob/main/R/cyberpunklines.R

# * Setup a Color Palette ----
clrs <- colorRampPalette(c("#00ff9f", "#00b8ff", "#001eff", "#bd00ff", "#d600ff"))(7)

scales::show_col(clrs)

clr_bg   <- "black"
clr_bg2  <- "gray10"
clr_grid <- "gray30"
clr_text <- "#d600ff"

# * Setup a ggplot theme ----
theme_cyberpunk <- function() {
    theme(
        # Plot / Panel
        plot.background = element_rect(fill = clr_bg, colour = clr_bg),
        # plot.margin = margin(1.5, 2, 1.5, 1.5, "cm"),
        panel.background = element_rect(fill = clr_bg, color = clr_bg),
        # Grid
        panel.grid = element_line(colour = clr_grid, size = 1),
        panel.grid.major = element_line(colour = clr_grid, size = 1),
        panel.grid.minor = element_line(colour = clr_grid, size = 1),
        axis.ticks.x = element_line(colour = clr_grid, size = 1),
        axis.line.y = element_line(colour = clr_grid, size = 0.5),
        axis.line.x = element_line(colour = clr_grid, size = 0.5),
        # Text
        plot.title = element_text(colour = clr_text),
        plot.subtitle = element_text(colour = clr_text),
        axis.text = element_text(colour = clr_text),
        axis.title = element_text(colour = clr_text),
        # Legend
        legend.background = element_blank(),
        legend.key = element_blank(),
        legend.title = element_text(colour = clr_text),
        legend.text = element_text(colour = "gray80", size = 12, face = "bold"),
        # Strip
        strip.background = element_rect(fill = clr_bg2, color = clr_bg2)
    )
}

# * Make Custom ggplot ----
g_cyberpunk <- g1 +
    geom_area(position = "identity", alpha = 0.5) +
    geom_line(aes(color = id), size = 1) +
    scale_color_manual(values = clrs) +
    geom_smooth(
        aes(Date, Weekly_Sales),
        inherit.aes = FALSE,
        se = FALSE
    ) +
    scale_y_continuous(labels = scales::dollar) +
    # facet_wrap(facets = NULL) +
    labs(title = "Cyberpunk 2077 Theme", subtitle = "Time Series Plot") +
    theme_cyberpunk()


g_cyberpunk

# * Make Interactive plotly ----
ggplotly(g_cyberpunk)

