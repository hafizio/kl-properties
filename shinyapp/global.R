library(shiny)
library(leaflet) # to render leaflet map
library(geojsonio) # to read geojson
library(dplyr) # to select
library(stringr) # to replace string
library(scales)
library(plyr)
library(DT) # to display table

c_geojsonPath <- "data/09-WPKL-New-DM-4326.geojson"
c_propDataPath <- "data/properties.csv"

# define the constant here
g_option_view <- c("Property price"="Price", "Per square feet"="Psf")

# the topic title holder
g_topic_title <- 'Please enter a link'

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
g_oriPropData <- read.csv(file = c_propDataPath)
propData <- g_oriPropData
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
  propData$LocationGroup[propData$LocationGroup == "kepong, Kuala Lumpur"] <-"PEKAN KEPONG"
  propData$LocationGroup[propData$LocationGroup == "Sentul, Kuala Lumpur"]
  propData$LocationGroup[propData$LocationGroup == "Sentul, Kuala Lumpur"] <-"SENTUL TENGAH"
  propData$LocationGroup[propData$LocationGroup == "Jinjang, Kuala Lumpur"]
  propData$LocationGroup[propData$LocationGroup == "Jinjang, Kuala Lumpur"] <-"JINJANG TENGAH"
  propData$LocationGroup[propData$LocationGroup == "Gombak, Kuala Lumpur"]
  propData$LocationGroup[propData$LocationGroup == "Gombak, Kuala Lumpur"] <-"GOMBAK SELATAN"
  propData$LocationGroup[propData$LocationGroup == "Ampang, Kuala Lumpur"] <-"JALAN AMPANG"
  propData$LocationGroup[propData$LocationGroup == "Bangsar, Kuala Lumpur"] <-"BANGSAR BARU"
  propData$LocationGroup[propData$LocationGroup == "Brickfields, Kuala Lumpur"] <-"BRICKFIELDS SELATAN"
  propData$LocationGroup[propData$LocationGroup == "Bukit Jalil, Kuala Lumpur"] <-"BUKIT JALIL"
  propData$LocationGroup[propData$LocationGroup == "Chan Sow Lin, Kuala Lumpur"] <-"JALAN CHAN SOW LIN"
  propData$LocationGroup[propData$LocationGroup == "Dutamas, Kuala Lumpur"] <-"DUTAMAS"
  propData$LocationGroup[propData$LocationGroup == "Jalan Sultan Ismail, Kuala Lumpur"] <-"JALAN SULTAN"
  propData$LocationGroup[propData$LocationGroup == "Jinjang, Kuala Lumpur"] <-"JINJANG TENGAH"
  propData$LocationGroup[propData$LocationGroup == "Sentul, Kuala Lumpur"] <-"SENTUL PASAR"
  propData$LocationGroup[propData$LocationGroup == "Kuchai Lama, Kuala Lumpur"] <-"KUCHAI"
  propData$LocationGroup[propData$LocationGroup == "Seputeh, Kuala Lumpur"] <-"SEPUTEH"
  propData$LocationGroup[propData$LocationGroup == "Setapak, Kuala Lumpur"] <-"SETAPAK UTARA"
  propData$LocationGroup[propData$LocationGroup == "KL City, Kuala Lumpur"] <-"BUKIT NANAS"
  propData$LocationGroup[propData$LocationGroup == "KLCC, Kuala Lumpur"] <-"BUKIT NANAS"
  # TODO : more to map!!!
  
  # show the row without price
  propData[-which(propData$Price == ""), ]
  # remove the row without price
  propData <- propData[!(is.na(propData$Price) | propData$Price==""), ]
  
  
  # clean up the price
  # format the price
  class(propData$Price)
  propData$Price <- str_replace_all(
    propData$Price, # column we want to search
    pattern = ',', # what to find
    replacement = '' # what to replace it with
  )
  propData$Price <- str_replace_all(
    propData$Price, # column we want to search
    pattern = 'RM', # what to find
    replacement = '' # what to replace it with
  )
  # check if there na 
  propData$Price[is.na(propData$Price)]
  # convert to numeric
  propData$Price <- as.numeric(propData$Price)
  
  
  # clean up the psf
  # TODO : alot noise here... 
  # 20 x 80, 850sf~1000sf, 
  head(propData)
  propData$Size <- str_replace_all(
    propData$Size,
    pattern = 'Built-up : ',
    replacement = ''
  )
  propData$Size <- str_replace_all(
    propData$Size,
    pattern = 'Land area : ',
    replacement = ''
  )
  propData$Size <- str_replace_all(
    propData$Size,
    pattern = ' sq. ft.',
    replacement = ''
  )
  propData$Size <- str_replace_all(
    propData$Size,
    pattern = ',',
    replacement = ''
  )
  propData$Size <- as.numeric(propData$Size)
  
  
  
  # show the names of the dataframe
  colnames(propData)
  
  
  
# take the "Price" and "LocationGroup"
propPriceData <- propData %>% select(-Location, -Rooms, -Bathrooms, -Furnishing, -Car.Parks, -Property.Type)
  # check the new dataframe
  head(propPriceData)
  colnames(propPriceData)
  class(propPriceData$Price) # the price is character
  
  
# grouping the same LocationGroup
groupedPropData <- ddply(propPriceData, .(LocationGroup), summarize,  MeanPrice=mean(Price), MeanSize=mean(Size, na.rm=T))
class(groupedPropData)


areaPriceData <- left_join(g_area_df, groupedPropData, by="LocationGroup")
# calculate the psf
areaPriceData$psf <- areaPriceData$MeanPrice / areaPriceData$MeanSize

class(areaPriceData)
head(areaPriceData)
# TODO : fill up the empty area with the same group
# TODO : how to copy row to the same area
