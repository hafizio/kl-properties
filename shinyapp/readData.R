library(rgdal) # to read OGR
library(sp) # rgdal dependency (Error in ogrListLayers(dsn = dsn) : Cannot open data source)

c_railwaysPath <- "data/planet_101.54_2.904_55fa5645-shp/shape/railways.shp"
c_pointsPath <- "data/planet_101.54_2.904_55fa5645-shp/shape/points.shp"
c_buildingsPath <- "data/planet_101.54_2.904_55fa5645-shp/shape/buildings.shp"
c_landusePath <- "data/planet_101.54_2.904_55fa5645-shp/shape/landuse.shp"
c_naturalPath <- "data/planet_101.54_2.904_55fa5645-shp/shape/natural.shp"
c_placesPath <- "data/planet_101.54_2.904_55fa5645-shp/shape/places.shp"

# TODO : plot the station, can found in points???
subwayLines <- readOGR(c_railwaysPath, stringsAsFactors = FALSE)

# TODO : extract bank, hospital, fuel, restaurant from the POI
points <- readOGR(c_pointsPath, stringsAsFactors = FALSE)
# head(points)
# check the unique type available
# unique(points$type)
hospital <- points[points$type == 'hospital',]
school <- points[points$type == 'school',]
fuel <- points[points$type == 'fuel',]
police <- points[points$type == 'police',]
university <- points[points$type == 'university',]
# childcare too less, no need show
# childcare <- points[points$type == 'childcare',]
atm <- points[points$type == 'atm',]



# TODO : too big file
#buildings <- readOGR(c_buildingsPath, stringsAsFactors = FALSE)
#head(buildings)

# landuse <- readOGR(c_landusePath, stringsAsFactors = FALSE)
# head(landuse)

# natural <- readOGR(c_naturalPath, stringsAsFactors = FALSE)
# head(natural)

# places <- readOGR(c_placesPath, stringsAsFactors = FALSE)
# head(places$name)
# colnames(places)
# class(places)

# c_controlGroup <- c("Subway", "School", "Police Station", "Fuel Station", "University", "Childcare", "ATM", "Hospital") # , "Buildings", "Land use", "Natural", "Places")
c_controlGroup <- c("School", "Police Station", "Fuel Station", "University", "ATM", "Hospital") # , "Buildings", "Land use", "Natural", "Places")
