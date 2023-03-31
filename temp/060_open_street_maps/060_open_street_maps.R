# BUSINESS SCIENCE R TIPS ----
# R-TIP 060 | Get Geospatial Data For Free (and map it too)  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://docs.ropensci.org/osmdata/

# LIBRARIES ----
library(osmdata)
library(mapview)
library(tidyverse)

# 1. AVAILABLE FEATURES -----
available_features()

# 2. BOUNDING BOX ----
pittsburg_bb <- getbb("Pittsburgh PA")

# 3. GET CUSTOMER LEADS ----
pittsburgh_pharmacies_sf <- pittsburg_bb %>%
    opq() %>%
    add_osm_feature(
        key   = "amenity",
        value = "pharmacy"
    ) %>%
    osmdata_sf()



# BONUS: MAPPING WITH SIMPLE FEATURES ----

mapview(pittsburgh_pharmacies_sf$osm_points)

# PRO-TIP :
#   COMBINE WITH R-TIP 59 TO GET ALL THE ADDRESSES OF THE PHARMACIES!


# LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


