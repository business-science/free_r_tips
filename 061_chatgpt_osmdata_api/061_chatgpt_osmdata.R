# BUSINESS SCIENCE R TIPS ----
# R-TIP 061 | ChatGPT + Open Street Maps Nominatum API  ----
#
# 👉 For Weekly R-Tips, Sign Up Here:
#    https://learn.business-science.io/r-tips-newsletter
#
# **** -----

# GOAL: Demonstrate how to get lat/long and map for ANY

# 1.0 CHATGPT + OSMDATA LESSON -----

# * CHATGPT PROMPT ----
"
Using the osmdata R library, write R code to find the locations of all pharmacies in
Pittsburgh. Then use mapview to visualize the pharmacies on a map.
"

# * FINAL RESPONSE ----

# load necessary packages
library(osmdata)
library(mapview)

# define the bounding box for Pittsburgh
bbox <- getbb("Pittsburgh")

# search for pharmacies within the bounding box
pharmacies <- opq(bbox) %>%
    add_osm_feature(key = "amenity", value = "pharmacy") %>%
    osmdata_sp()

# visualize the pharmacies on a map
mapview(pharmacies$osm_points)


# 2.0 PREVIEW LEARNING LAB 83 ----
# - Extends this lesson
# - Demo Geospatial App I built



# 3.0 LEARNING MORE ----
# - Do you want to become the data science expert for your organization?
# - HERE'S HOW: 10 SECRETS TO BECOMING A 6-FIGURE DATA SCIENTIST
#   https://learn.business-science.io/free-rtrack-masterclass

