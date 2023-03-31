# BUSINESS SCIENCE R TIPS ----
# R-TIP 059 | Geocoding for FREE in R  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter

# Documentation: https://jessecambon.github.io/tidygeocoder/


# LIBRARIES ----
library(tidyverse)
library(tidygeocoder)
library(sf)
library(mapview)

# DATA ----
# (will show how to get this from an API in R-Tip 60)

pittsburgh_pharmacies_tbl <- read_csv("059_geocoding/pittsburgh_pharmacies_geocoded.csv")
pittsburgh_pharmacies_tbl


# 1.0 GEOCODING -----
# - Have address, want Lat/Long
# - Important for geospatial analysis

geo_code_tbl <- pittsburgh_pharmacies_tbl %>%

    # Pretend we dont have lat/lon...
    slice(1:10) %>%
    select(-lat, -lon) %>%

    # Geocode Address to Lat/Lon
    tidygeocoder::geocode(
        address = address,
        method = "osm"
    )

# 2.0 REVERSE GEOCODING -----
# - Have Lat/Long, Want Physical Address
# - Important for Sales People that Travel

geo_reverse_tbl <- pittsburgh_pharmacies_tbl %>%

    # Pretend we don't have the address...
    slice(1:10) %>%
    select(-address) %>%

    # Go from Lat/Lon to Address
    tidygeocoder::reverse_geocode(
        lat    = lat,
        long   = lon,
        method = "osm"
    )


# BONUS: MAPPING WITH SIMPLE FEATURES ----

pittsburgh_pharmacies_sf <- pittsburgh_pharmacies_tbl %>%
    st_as_sf(
        coords = c("lon", "lat"),
        crs    = 4326
    )

pittsburgh_pharmacies_sf %>% mapview()



# LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass


