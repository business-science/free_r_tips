# R TIPS ----
# TIP 013 | Tidyverse Features: Making Maps w/ ggplot ----
# - ggplot
# - Map Data: Coordinates & Lat/Lon
#
# 👉 For Weekly R-Tips, Sign Up Here: https://mailchi.mp/business-science/r-tips-newsletter

# LIBRARIES ----
library(tidyverse)
library(maps)
library(mapproj)

# 1.0 MAP DATA -----
?map_data()


# 2.0 WORLD MAP ----
# - ggplot is covered in DS4B 101-R Week 4

world_tbl <- map_data("world") %>%
    as_tibble()

world_tbl

# * World Base ----
world_base <- world_tbl %>%
    ggplot() +
    geom_map(
        aes(long, lat, map_id = region),
        map = world_tbl,
        color = "gray80", fill = "gray30", size = 0.3
    )

world_base

# * Ortho Projection ----

world_base +
    coord_map("ortho", orientation = c(39, -98, 0))

# 3.0 STATE MAPS ----
# - ggplot is covered in DS4B 101-R Week 4

usa_tbl <- map_data("state") %>% as_tibble()

usa_tbl %>%
    ggplot(aes(long, lat, map_id = region)) +
    geom_map(
        map = usa_tbl,
        color = "gray80", fill = "gray30", size = 0.3
    ) +
    coord_map("ortho", orientation = c(39, -98, 0))



# 4.0 REPUBLICAN VOTING BY US STATE ----
# - dplyr is covered in DS4B 101-R Weeks 2 & 3
# - ggplot2 is covered in DS4B 101-R Week 4

# * Wrangle & Join Data (dplyr) ----
republican_voting_tbl <- maps::votes.repub %>%
    as_tibble(rownames = "state") %>%
    select(state, `1976`) %>%
    rename(repub_prop = `1976`) %>%
    mutate(repub_prop = repub_prop / 100) %>%
    mutate(state = str_to_lower(state))

usa_voting_tbl <- usa_tbl %>%
    left_join(republican_voting_tbl, by = c("region" = "state"))

usa_voting_tbl

# * Make Map (ggplot2) ----
usa_voting_tbl %>%
    ggplot(aes(long, lat, group = subregion)) +
    geom_map(
        aes(map_id = region),
        map = usa_tbl,
        color = "gray80", fill = "gray30", size = 0.3
    ) +
    coord_map("ortho", orientation = c(39, -98, 0)) +
    geom_polygon(aes(group = group, fill = repub_prop), color = "black") +
    scale_fill_gradient2(low = "blue", mid = "white", high = "red",
                         midpoint = 0.5, labels = scales::percent) +
    theme_minimal() +
    labs(
        title = "Voting Republican in 1976",
        x = "", y = "", fill = ""
    ) +
    theme(
        plot.title = element_text(size = 26, face = "bold", color = "red3"),
        legend.position = "bottom"
    )














