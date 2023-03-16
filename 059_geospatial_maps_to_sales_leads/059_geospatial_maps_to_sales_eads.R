



library(osmdata)
library(mapview)
library(tidyverse)

osmdata::available_features()

pittsburg_bb <- getbb("Pittsburgh PA")

pittsburgh_pharmacies_sf <- pittsburg_bb %>%
    opq() %>%
    add_osm_feature(
        key = "amenity",
        value = "pharmacy"
    ) %>%
    osmdata_sf()

pittsburgh_pharmacies_sf$osm_points %>% write_rds("059_mapping_leads/pittsburg_pharmacies.rds")

read_rds("059_mapping_leads/pittsburg_pharmacies.rds")

pittsburgh_pharmacies_sf$osm_points %>% mapview()

pittsburgh_pharmacies_sf$osm_points %>%
    as_tibble() %>%
    glimpse() %>%
    mutate(`addr:full_addr` = str_glue("{`addr:housenumber`} {`addr:street`}, {`addr:city`}, {`addr:state`} {`addr:postcode`}")) %>%
    select(osm_id, name, `addr:full_addr`, opening_hours, phone, geometry)
