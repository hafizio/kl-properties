library(shiny)
library(leaflet) # to render leaflet map
library(geojsonio) # to read geojson
library(dplyr) # to select
library(stringr) # to replace string
library(scales)
library(plyr)

c_geojsonPath <- "data/09-WPKL-New-DM-4326.geojson"
c_propDataPath <- "data/properties.csv"

# read the geojson as "SpatialPolygonsDataFrame"
g_geojson <- geojson_read(c_geojsonPath, what = "sp")
class(g_geojson)
colnames(g_geojson)
g_areaList <- g_geojson$NAMA_DM
class(g_areaList)
colnames(g_areaList)

# mapping the area name according to geojson
g_area_df <- data.frame("LocationGroup" = g_areaList)

# TODO : here we clean up our R. mayb extract this function to another class file
# Import the data
propData <- read.csv(file = c_propDataPath)
  # look at the first six rows
  head(propData)
  class(propData) # it is dataframe
  # create a new area grouping
  propData$LocationGroup <- propData$Location 
  # add the new column to the dataframe
  cbind(propData, propData$LocationGroup)
  # replace value...
  propData$LocationGroup <- as.character(propData$LocationGroup)
  propData$LocationGroup[propData$LocationGroup == "Cheras, Kuala Lumpur"]
  propData$LocationGroup[propData$LocationGroup == "Cheras, Kuala Lumpur"] <-"CHERAS BARU"
  propData$LocationGroup[propData$LocationGroup == "Kepong, Kuala Lumpur"]
  propData$LocationGroup[propData$LocationGroup == "Kepong, Kuala Lumpur"] <-"PEKAN KEPONG"
  propData$LocationGroup[propData$LocationGroup == "Sentul, Kuala Lumpur"]
  propData$LocationGroup[propData$LocationGroup == "Sentul, Kuala Lumpur"] <-"SENTUL TENGAH"
  propData$LocationGroup[propData$LocationGroup == "Jinjang, Kuala Lumpur"]
  propData$LocationGroup[propData$LocationGroup == "Jinjang, Kuala Lumpur"] <-"JINJANG TENGAH"
  propData$LocationGroup[propData$LocationGroup == "Gombak, Kuala Lumpur"]
  propData$LocationGroup[propData$LocationGroup == "Gombak, Kuala Lumpur"] <-"GOMBAK SELATAN"
  # more to map!!!
  
  # show the row without price
  propData[-which(propData$Price == ""), ]
  # remove the row without price
  propData <- propData[!(is.na(propData$Price) | propData$Price==""), ]
  
  # clean up the price
  # format the price
  propData$Price[propData$Price == "Gombak, Kuala Lumpur"] <-"GOMBAK SELATAN"
  class(propData$Price)
  propData$Price <- str_replace(
    propData$Price, # column we want to search
    pattern = ',', # what to find
    replacement = '' # what to replace it with
  )
  propData$Price <- str_replace(
    propData$Price, # column we want to search
    pattern = ',', # what to find
    replacement = '' # what to replace it with
  )
  propData$Price <- str_replace(
    propData$Price, # column we want to search
    pattern = 'RM', # what to find
    replacement = '' # what to replace it with
  )
  propData$Price[is.na(propData$Price)]
  propData$Price <- as.numeric(propData$Price)
  
  # show the names of the dataframe
  colnames(propData)
# take the "Price" and "LocationGroup"
propPriceData <- propData %>% select(-Location, -Rooms, -Bathrooms, - Size, -Furnishing, -Car.Parks, -Property.Type)
  # check the new dataframe
  head(propPriceData)
  colnames(propPriceData)
  class(propPriceData$Price) # the price is character
# grouping the same LocationGroup
groupedPropData <- ddply(propPriceData, .(LocationGroup), summarize,  Rate1=mean(Price))
class(groupedPropData)

areaPriceData <- left_join(g_area_df, groupedPropData, by="LocationGroup")
