# BUSINESS SCIENCE R TIPS ----
# R-TIP 061 | ChatGPT + Open Street Maps Nominatum API  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter
#
# **** -----

# GOAL: Demonstrate how to get & map lat/long for ANY business type

# 1.0 CHATGPT + OSMDATA LESSON -----

# * CHATGPT PROMPT ----
"
Using the osmdata R library, write R code to find the locations of all pharmacies in
Pittsburgh. Then use mapview to visualize the pharmacies on a map.
"

# * FINAL RESPONSE ----

# Load required libraries
library(osmdata)
library(mapview)

# Get the bounding box for Pittsburgh
pittsburgh_bbox <- getbb("Pittsburgh, Pennsylvania, USA")

# Create an Overpass query for pharmacies in Pittsburgh
query <- opq(bbox = pittsburgh_bbox) %>%
    add_osm_feature(key = "amenity", value = "pharmacy")

# Extract the data as an sf object
pharmacies_sf <- osmdata_sf(query)

# Visualize the pharmacies on a map
mapview(pharmacies_sf$osm_points, zcol = "name")




# 2.0 PREVIEW LEARNING LAB 83 ----
# - Extends this lesson
# - Demo Geospatial App I built



# 3.0 LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

