library(rgdal) # to read OGR
library(sp) # rgdal dependency (Error in ogrListLayers(dsn = dsn) : Cannot open data source)

c_railwaysPath <- "data/planet_101.54_2.904_55fa5645-shp/shape/railways.shp"
c_pointsPath <- "data/planet_101.54_2.904_55fa5645-shp/shape/points.shp"

subwayLines <- readOGR(c_railwaysPath, stringsAsFactors = FALSE)

# TODO : extract bank, hospital, fuel, restaurant from the POI
points <- readOGR(c_pointsPath, stringsAsFactors = FALSE)
head(points)
# TODO : check again do we need proj=longlat?
points <- spTransform(points, CRS("+proj=longlat +datum=WGS84 +no_defs"))
head(points)

c_controlGroup <- c("Subway", "POI")
