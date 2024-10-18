

# LIBRARIES AND DATA ----

# install.packages("planr")

library(tidyverse)
library(timetk)
library(reactable)
library(reactablefmtr)
library(htmltools)
library(planr)

source("087_supply_chain_planr/supply_demand_helpers.R")

# Supply Data ----

supply_demand_tbl <- read_csv("087_supply_chain_planr/data/supply_demand.csv")

supply_demand_tbl %>%
    group_by(DFU) %>%
    plot_time_series(Period, Demand, .facet_ncol = 3)


# Projected Inventories

projected_inventories_tbl <- supply_demand_tbl %>%
    planr::light_proj_inv(
        DFU     = DFU,
        Period  = Period,
        Demand  = Demand,
        Opening = Opening,
        Supply  = Supply
    )

projected_inventories_tbl %>%
    generate_supply_chain_table()
