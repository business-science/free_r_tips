# BUSINESS SCIENCE R TIPS ----
# R-TIP 87 | SUPPLY CHAIN ANALYSIS IN R WITH PLANR ----

# Goal: Get started with supply chain analysis in R using `planr`

# Step 1: Load Libraries and Data ----

# install.packages("planr")

library(tidyverse)
library(timetk)
library(reactable)
library(reactablefmtr)
library(htmltools)
library(planr)

source("087_supply_chain_planr/supply_demand_helpers.R")

# Supply Data

supply_demand_tbl <- read_csv("087_supply_chain_planr/data/supply_demand.csv")


# Step 2: Visualizing Demand Over Time ----

supply_demand_tbl %>%
    group_by(DFU) %>%
    plot_time_series(Period, Demand, .facet_ncol = 3)


# Step 3: Projecting Inventory Levels ----

projected_inventories_tbl <- supply_demand_tbl %>%
    planr::light_proj_inv(
        DFU     = DFU,
        Period  = Period,
        Demand  = Demand,
        Opening = Opening,
        Supply  = Supply
    )

projected_inventories_tbl

# Step 4: Creating an Interactive Table for Projected Inventories ----

projected_inventories_tbl %>%
    generate_supply_chain_table()
