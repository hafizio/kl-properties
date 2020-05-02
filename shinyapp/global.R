library(shiny)
library(leaflet) # to render leaflet map
library(geojsonio) # to read geojson

g_geojson <- geojson_read("data/09-WPKL-New-DM-4326.geojson", what = "sp")
