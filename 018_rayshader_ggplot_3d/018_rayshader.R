# R TIPS ----
# TIP 018 | 3D GGPLOTS w/ Rayshader ----
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter


# LIBRARIES ----

library(rayshader)
library(tidyverse)


# 3D DATA PLOT ----

# ggplot (2D visualization) - DS4B 101-R, Week 4
g1 <- mtcars %>%
    ggplot(aes(disp, mpg, color = cyl)) +
    geom_point(size=2) +
    scale_color_continuous(limits=c(0,8)) +
    ggtitle("mtcars: Displacement vs mpg vs # of cylinders") +
    theme(title = element_text(size=8),
          text = element_text(size=12))

# rayshader
g1 %>%
    plot_gg(
        height        = 3,
        width         = 3.5,
        multicore     = TRUE,
        pointcontract = 0.7,
        soliddepth    = -200
    )

render_camera(zoom = 0.75, theta = -30, phi = 30)
render_snapshot(clear = FALSE)

# 3D ELEVATION MATRIX ----
volcano

volcano %>% class()

# dplyr (data wrangling) - DS4B 101-R, Weeks 2&3
volcano_tbl <- volcano %>%
    as_tibble(.name_repair = "minimal") %>%
    set_names(str_c("V", seq_along(names(.)))) %>%
    rowid_to_column(var = "x") %>%
    pivot_longer(
        cols      = contains("V"),
        names_to  = "y",
        values_to = "value"
    ) %>%
    mutate(y = str_remove(y, "^V") %>% as.numeric())

# ggplot (visualization) - DS4B 101-R, Week 4
g2 <- volcano_tbl %>%
    ggplot(aes(x = x, y = y, fill = value)) +
    geom_tile() +
    geom_contour(aes(z = value), color = "black") +
    scale_x_continuous("X", expand = c(0,0)) +
    scale_y_continuous("Y",expand = c(0,0)) +
    scale_fill_gradientn("Z", colours = terrain.colors(10)) +
    coord_fixed()

# rayshader

g2 %>%
    plot_gg(
        multicore = TRUE,
        raytrace = TRUE,
        width = 7,
        height = 4,
        scale = 300,
        windowsize = c(1400, 866),
        zoom = 0.6,
        phi = 30,
        theta = 30
    )



# 3D Elevation Plots ----
# - plot_3d from matrix

volcano %>%
    sphere_shade() %>%
    plot_3d(volcano, zscale = 3)

