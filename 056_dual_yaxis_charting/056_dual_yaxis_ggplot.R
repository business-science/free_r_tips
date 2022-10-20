# BUSINESS SCIENCE R TIPS ----
# R-TIP 056 | ggplot: dual y-axis charts  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://ggplot2.tidyverse.org/reference/sec_axis.html

# LIBRARIES ----

library(tidyverse)
library(tidyquant)

# DATA ----

mpg

# DATA AGGREGATIONS ----

mpg_summarized_tbl <- mpg %>%
    select(-year) %>%
    group_by(class) %>%
    summarise(
        across(
            .cols  = where(is.numeric),
            .fns   = median,
            .names = "{.col}_median"
        ),
        count = n()
    ) %>%
    ungroup() %>%
    mutate(
        prop       = count / sum(count),
        all_groups = "all_groups",
        class      = fct_reorder(class, prop)
    )

mpg_summarized_tbl

# 1.0 PROBLEM ----

mpg_summarized_tbl %>%
    ggplot(aes(x = class)) +

    geom_col(aes(y = prop)) +
    geom_label(aes(
        y     = prop,
        label = str_glue("{scales::percent(prop)}")
    )) +

    geom_line(aes(y = hwy_median, group = all_groups)) +
    geom_point(aes(y = hwy_median, group = all_groups))

# 2.0 DUAL Y-AXIS PLOTTING TRANSFORMER ----

# * Transformer Function ----
transformer_dual_y_axis <- function(data,
                                    primary_column, secondary_column,
                                    include_y_zero = FALSE) {

    # PARAMETER SETUP
    params_tbl <- data %>%
        summarise(
            max_primary   = max(!! enquo(primary_column)),
            min_primary   = min(!! enquo(primary_column)),
            max_secondary = max(!! enquo(secondary_column)),
            min_secondary = min(!! enquo(secondary_column))
        )

    if (include_y_zero) {
        params_tbl$min_primary   <- 0
        params_tbl$min_secondary <- 0
    }

    params_tbl <- params_tbl %>%
        mutate(
            scale = (max_secondary - min_secondary) / (max_primary - min_primary),
            shift = min_primary - min_secondary
        )

    # MAKE SCALER FUNCTIONS
    scale_func <- function(x) {
        x * params_tbl$scale - params_tbl$shift
    }

    inv_func <- function(x) {
        (x + params_tbl$shift) / params_tbl$scale
    }

    # RETURN
    ret <- list(
        scale_func = scale_func,
        inv_func   = inv_func,
        params_tbl = params_tbl
    )

    return(ret)
}

# * Make A Y-Axis Transformer ----
transformer <- mpg_summarized_tbl %>%
    transformer_dual_y_axis(
        primary_column   = prop,
        secondary_column = hwy_median,
        include_y_zero   = TRUE
    )

# * How the transformer works... ----
mpg_summarized_tbl %>%
    pull(hwy_median) %>%
    transformer$inv_func() %>%
    transformer$scale_func()


# 3.0 PLOTTING WITH DUAL Y-AXIS ----

# * 3.1 PRIMARY Y-AXIS ----

g1 <- mpg_summarized_tbl %>%
    ggplot(aes(x = class)) +


    geom_col(
        aes(y = prop, fill = "Vehicle Proportion (%)"),
        alpha = 0.9
    ) +
    geom_label(
        aes(
            y     = prop,
            label = str_glue("{scales::percent(prop)}"),
            color = "Vehicle Proportion (%)"
        )
    )

g1

# * 3.2 SECONDARY AXIS ----

g2 <- g1 +
    geom_line(
        aes(
            y     = transformer$inv_func(hwy_median),
            group = all_groups,
            color = "Highway MPG"
        ),
        size = 1
    ) +
    geom_point(
        aes(
            y     = transformer$inv_func(hwy_median),
            group = all_groups,
            color = "Highway MPG"
        ),
        size = 5
    ) +
    geom_label(
        aes(
            y     = transformer$inv_func(hwy_median),
            label = str_glue("{hwy_median} mpg"),
            color = "Highway MPG"
        ),
        size = 3,
        nudge_y = 0.008
    ) +

    scale_y_continuous(
        labels   = scales::percent_format(),
        name     = "Vehicle Proportion (%)",
        sec.axis = sec_axis(
            trans = ~ transformer$scale_func(.),
            name  = "Highway MPG"
        )
    ) +
    expand_limits(y = c(0,0.30))

g2

# * 3.3 THEME ----

g3 <- g2 +
    theme_tq() +
    scale_color_manual(values = c(
        palette_light()[["red"]],
        palette_light()[["blue"]]
    )) +
    scale_fill_manual(values = palette_light()[["blue"]]) +
    theme(
        legend.position    = "none",
        axis.title.y.right = element_text(color = palette_light()[["red"]]),
        axis.text.y.right  = element_text(color = palette_light()[["red"]])
    ) +
    labs(title = "Dual Y-Axis Plot: Vehicle Class Proportion vs Fuel Economy")

g3

# LEARNING MORE ----
# - Has your data science progress has stopped?

# FREE MASTERCLASS
# - 10 SECRETS TO BECOMING A DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass




