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

# for the ui link
proptalkURL <- a("Find Topic Here!!", href="https://forum.lowyat.net/PropertyTalk")

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
  str(propData)
  # look at the first six rows
  head(propData)
  class(propData) # it is dataframe
  # create a new area grouping
  propData$LocationGroup <- propData$Location 
  # add the new column to the dataframe
  cbind(propData, propData$LocationGroup)
  # replace value...
  propData$LocationGroup <- as.character(propData$LocationGroup)
  propData$LocationGroup[propData$LocationGroup == "Cheras, Kuala Lumpur"] <-"CHERAS BARU"
  propData$LocationGroup[propData$LocationGroup == "Sungai Long SL8, Kuala Lumpur"] <-"CHERAS BARU"
  
  propData$LocationGroup[propData$LocationGroup == "Kepong, Kuala Lumpur"] <-"PEKAN KEPONG"
  propData$LocationGroup[propData$LocationGroup == "kepong, Kuala Lumpur"] <-"PEKAN KEPONG"
  
  propData$LocationGroup[propData$LocationGroup == "Sentul, Kuala Lumpur"] <-"SENTUL TENGAH"
  
  propData$LocationGroup[propData$LocationGroup == "Jinjang, Kuala Lumpur"] <-"JINJANG TENGAH"
  propData$LocationGroup[propData$LocationGroup == "Jinjang, Kuala Lumpur"] <-"JINJANG TENGAH"
  
  propData$LocationGroup[propData$LocationGroup == "Gombak, Kuala Lumpur"] <-"GOMBAK SELATAN"
  
  propData$LocationGroup[propData$LocationGroup == "Ampang, Kuala Lumpur"] <-"JALAN AMPANG"
  #propData$LocationGroup[propData$LocationGroup == "Taman TAR, Kuala Lumpur"] <-"JALAN AMPANG"
  propData$LocationGroup[propData$LocationGroup == "U-THANT, Kuala Lumpur"] <-"JALAN AMPANG"
  
  propData$LocationGroup[propData$LocationGroup == "Jalan Sultan Ismail, Kuala Lumpur"] <-"KAMPONG BHARU SELATAN"
  
  propData$LocationGroup[propData$LocationGroup == "Bangsar, Kuala Lumpur"] <-"BANGSAR BARU"
  
  propData$LocationGroup[propData$LocationGroup == "Brickfields, Kuala Lumpur"] <-"BRICKFIELDS SELATAN"
  
  propData$LocationGroup[propData$LocationGroup == "Bukit Jalil, Kuala Lumpur"] <-"BUKIT JALIL"
  
  propData$LocationGroup[propData$LocationGroup == "Chan Sow Lin, Kuala Lumpur"] <-"JALAN CHAN SOW LIN"
  
  propData$LocationGroup[propData$LocationGroup == "Jalan Sultan Ismail, Kuala Lumpur"] <-"JALAN SULTAN"
  
  propData$LocationGroup[propData$LocationGroup == "Sentul, Kuala Lumpur"] <-"SENTUL PASAR"
  
  propData$LocationGroup[propData$LocationGroup == "Kuchai Lama, Kuala Lumpur"] <-"KUCHAI"
  
  propData$LocationGroup[propData$LocationGroup == "Seputeh, Kuala Lumpur"] <-"SEPUTEH"
  
  propData$LocationGroup[propData$LocationGroup == "Setapak, Kuala Lumpur"] <-"SETAPAK UTARA"
  
  propData$LocationGroup[propData$LocationGroup == "KL City, Kuala Lumpur"] <-"BUKIT NANAS"
  propData$LocationGroup[propData$LocationGroup == "KLCC, Kuala Lumpur"] <-"BUKIT NANAS"
  propData$LocationGroup[propData$LocationGroup == "Klcc, Kuala Lumpur"] <-"BUKIT NANAS"
  #propData$LocationGroup[propData$LocationGroup == "Landed Sd, Kuala Lumpur"] <-"BUKIT NANAS"
  
  propData$LocationGroup[propData$LocationGroup == "ADIVA Desa ParkCity, Kuala Lumpur"] <-"BANDAR MANJALARA"
  propData$LocationGroup[propData$LocationGroup == "Bandar Menjalara"] <-"BANDAR MANJALARA"
  propData$LocationGroup[propData$LocationGroup == "Bandar Sri Damansara"] <-"BANDAR MANJALARA"
  propData$LocationGroup[propData$LocationGroup == "Bandar Sri Damansara, Kuala Lumpur"] <-"BANDAR MANJALARA"
  propData$LocationGroup[propData$LocationGroup == "Desa ParkCity, Kuala Lumpur"] <-"BANDAR MANJALARA"
  propData$LocationGroup[propData$LocationGroup == "Sri Damansara, Kuala Lumpur"] <-"BANDAR MANJALARA"
  propData$LocationGroup[propData$LocationGroup == "Bandar Sri damansara, Kuala Lumpur"] <-"BANDAR MANJALARA"
  propData$LocationGroup[propData$LocationGroup == "Sunway SPK, Kuala Lumpur"] <-"BANDAR MANJALARA"
  propData$LocationGroup[propData$LocationGroup == "Bandar Menjalara, Kuala Lumpur"] <-"BANDAR MANJALARA"
  
  propData$LocationGroup[propData$LocationGroup == "Alam Damai, Kuala Lumpur"] <-"TAMAN BUKIT CHERAS"
  
  propData$LocationGroup[propData$LocationGroup == "Bandar Damai Perdana"] <-"TAMAN CHERAS"
  propData$LocationGroup[propData$LocationGroup == "Canary Residence, Kuala Lumpur"] <-"TAMAN CHERAS"
  
  propData$LocationGroup[propData$LocationGroup == "Bandar Tasik Selatan, Kuala Lumpur,"] <-"BANDAR TASIK SELATAN"
  #propData$LocationGroup[propData$LocationGroup == "The Mines Resort, Kuala Lumpur"] <-"BANDAR TASIK SELATAN"
  propData$LocationGroup[propData$LocationGroup == "Bandar Tasik Selatan, Kuala Lumpur"] <-"BANDAR TASIK SELATAN"
  
  propData$LocationGroup[propData$LocationGroup == "Bangsar South, Kuala Lumpur"] <-"KAWASAN UNIVERSITI"
  propData$LocationGroup[propData$LocationGroup == "Bangsar, Kuala Lumpur"] <-"KAWASAN UNIVERSITI"
  #propData$LocationGroup[propData$LocationGroup == "Jalan Klang Lama (Old Klang Road), Kuala Lumpur"] <-"KAWASAN UNIVERSITI"
  
  propData$LocationGroup[propData$LocationGroup == "Batu Caves, Kuala Lumpur"] <-"KAMPONG SELAYANG LAMA"
  
  propData$LocationGroup[propData$LocationGroup == "Brickfields, Kuala Lumpur"] <-"BRICKFIELDS SELATAN"
  
  propData$LocationGroup[propData$LocationGroup == "Bukit  Persekutuan, Kuala Lumpur"] <-"BRICKFIELDS UTARA"
  
  propData$LocationGroup[propData$LocationGroup == "Bukit Bintang, Kuala Lumpur"] <-"JALAN HANG TUAH"
  
  propData$LocationGroup[propData$LocationGroup == "Bukit Jalil, Kuala Lumpur"] <-"BUKIT JALIL"
  propData$LocationGroup[propData$LocationGroup == "Seri Kembangan, Kuala Lumpur"] <-"BUKIT JALIL"
  propData$LocationGroup[propData$LocationGroup == "Sri Kembangan, Kuala Lumpur"] <-"BUKIT JALIL"
  
  propData$LocationGroup[propData$LocationGroup == "Mont Kiara, Kuala Lumpur"] <-"SRI HARTAMAS"
  propData$LocationGroup[propData$LocationGroup == "duta Nusantara, Kuala Lumpur"] <-"SRI HARTAMAS"
  propData$LocationGroup[propData$LocationGroup == "Sri Hartamas, Kuala Lumpur"] <-"SRI HARTAMAS"
  
  propData$LocationGroup[propData$LocationGroup == "Bukit Kiara, Kuala Lumpur"] <-"TAMAN TUN DR ISMAIL TENGAH"
  propData$LocationGroup[propData$LocationGroup == "Taman Tun Dr Ismail, Kuala Lumpur"] <-"TAMAN TUN DR ISMAIL TENGAH"
  
  propData$LocationGroup[propData$LocationGroup == "Bukit Ledang, Kuala Lumpur"] <-"TAMAN BUNGA"
  propData$LocationGroup[propData$LocationGroup == "Bukit Tunku (Kenny Hills), Kuala Lumpur"] <-"TAMAN BUNGA"
  
  propData$LocationGroup[propData$LocationGroup == "Casa Rimba, Kuala Lumpur"] <-"TAMAN WANGSA MELAWATI"
  
  propData$LocationGroup[propData$LocationGroup == "City Centre, Kuala Lumpur"] <-"JALAN TUANKU ABDUL RAHMAN"
  
  propData$LocationGroup[propData$LocationGroup == "Country Heights Damansara, Kuala Lumpur"] <-"BUKIT LANJAN"
  
  propData$LocationGroup[propData$LocationGroup == "Bukit Damansara, Kuala Lumpur"] <-"BUKIT DAMANSARA"
  propData$LocationGroup[propData$LocationGroup == "Damansara Heights, Kuala Lumpur"] <-"BUKIT DAMANSARA"
  propData$LocationGroup[propData$LocationGroup == "Damansara, Kuala Lumpur"] <-"BUKIT DAMANSARA"
  propData$LocationGroup[propData$LocationGroup == "Kota Damansara, Kuala Lumpur"] <-"BUKIT DAMANSARA"
  propData$LocationGroup[propData$LocationGroup == "Taman Duta, Kuala Lumpur"] <-"BUKIT DAMANSARA"
  
  propData$LocationGroup[propData$LocationGroup == "Desa Pandan, Kuala Lumpur"] <-"DESA PANDAN"
  propData$LocationGroup[propData$LocationGroup == "Jalan U-Thant, Kuala Lumpur"] <-"DESA PANDAN"
  propData$LocationGroup[propData$LocationGroup == "Ampang Hilir, Kuala Lumpur"] <-"DESA PANDAN"
  
  propData$LocationGroup[propData$LocationGroup == "Desa Petaling, Kuala Lumpur"] <-"DESA PETALING"
  
  propData$LocationGroup[propData$LocationGroup == "Sri Petaling, Kuala Lumpur"] <-"TAMAN SRI PETALING"
  propData$LocationGroup[propData$LocationGroup == "Taman Yarl, Kuala Lumpur"] <-"TAMAN SRI PETALING"
  propData$LocationGroup[propData$LocationGroup == "Taman Yarl, UOG, Kuala Lumpur"] <-"TAMAN SRI PETALING"
  
  propData$LocationGroup[propData$LocationGroup == "Dutamas, Kuala Lumpur"] <-"DUTAMAS"
  propData$LocationGroup[propData$LocationGroup == "Solaris Dutamas, Kuala Lumpur"] <-"DUTAMAS"
  propData$LocationGroup[propData$LocationGroup == "Dutamas, Kuala Lumpur"] <-"DUTAMAS"
  
  propData$LocationGroup[propData$LocationGroup == "Federal Hill, Kuala Lumpur"] <-"BRICKFIELDS UTARA"
  propData$LocationGroup[propData$LocationGroup == "KL Sentral, Kuala Lumpur"] <-"BRICKFIELDS UTARA"
  
  propData$LocationGroup[propData$LocationGroup == "Gombak, Kuala Lumpur"] <-"GOMBAK UTARA"
  
  propData$LocationGroup[propData$LocationGroup == "Gurney, Kuala Lumpur"] <-"DATO KERAMAT TENGAH"
  propData$LocationGroup[propData$LocationGroup == "SEMARAK, Kuala Lumpur"] <-"DATO KERAMAT UTARA"
  
  propData$LocationGroup[propData$LocationGroup == "Happy Garden, Kuala Lumpur"] <-"KUCHAI ENTREPRENEURS PARK"
  propData$LocationGroup[propData$LocationGroup == "Jalan Ipoh, Kuala Lumpur"] <-"SENTUL SELATAN"
  propData$LocationGroup[propData$LocationGroup == "Jalan Kuching, Kuala Lumpur"] <-"KUCHAI"
  propData$LocationGroup[propData$LocationGroup == "Kemensah, Kuala Lumpur"] <-"TAMAN DESA SETAPAK"
  propData$LocationGroup[propData$LocationGroup == "Kepong, Kuala Lumpur"] <-"KEPONG UTARA"
  propData$LocationGroup[propData$LocationGroup == "Keramat, Kuala Lumpur"] <-"DATO KERAMAT SEBERANG"
  propData$LocationGroup[propData$LocationGroup == "KL City, Kuala Lumpur"] <-"JALAN TUN SAMBANTHAN"
  propData$LocationGroup[propData$LocationGroup == "KLCC, Kuala Lumpur"] <-"JALAN HANG TUAH"
  
  propData$LocationGroup[propData$LocationGroup == "Kuala Lumpur"] <-"BANDAR TUN RAZAK"
  propData$LocationGroup[propData$LocationGroup == "Kuala Lumpur, Kuala Lumpur"] <-"BANDAR TUN RAZAK"
  
  propData$LocationGroup[propData$LocationGroup == "Kuchai Lama, Kuala Lumpur"] <-"KUCHAI ENTREPRENEURS PARK"
  propData$LocationGroup[propData$LocationGroup == "Mid Valley City, Kuala Lumpur"] <-"SEPUTEH"
  propData$LocationGroup[propData$LocationGroup == "OUG, Kuala Lumpur"] <-"TAMAN OVERSEAS UNION SELATAN"
  propData$LocationGroup[propData$LocationGroup == "Pandan Indah, Kuala Lumpur"] <-"TAMAN MALURI"
  propData$LocationGroup[propData$LocationGroup == "Pandan Jaya, Kuala Lumpur"] <-"TAMAN MALURI"
  propData$LocationGroup[propData$LocationGroup == "Pandan Perdana, Kuala Lumpur"] <-"TAMAN SHAMELIN PERKASA"
  propData$LocationGroup[propData$LocationGroup == "Pantai, Kuala Lumpur"] <-"SEPUTEH"
  propData$LocationGroup[propData$LocationGroup == "Rawang, Kuala Lumpur"] <-"KAMPONG SELAYANG LAMA"
  propData$LocationGroup[propData$LocationGroup == "Salak Selatan, Kuala Lumpur"] <-"SALAK SELATAN"
  propData$LocationGroup[propData$LocationGroup == "Santuari Park Pantai, Kuala Lumpur"] <-"PANTAI DALAM"
  propData$LocationGroup[propData$LocationGroup == "Segambut, Kuala Lumpur"] <-"SEGAMBUT"
  propData$LocationGroup[propData$LocationGroup == "Sentul, Kuala Lumpur"] <-"BANDAR BARU SENTUL"
  #propData$LocationGroup[propData$LocationGroup == "Singapore, Kuala Lumpur"] <-"TAMAN MIDAH KANAN"
  propData$LocationGroup[propData$LocationGroup == "Sungai Penchala, Kuala Lumpur"] <-"KAMPONG SUNGAI PENCHALA"
  
  propData$LocationGroup[propData$LocationGroup == "taman cheras perdana, Kuala Lumpur"] <-"JALAN CHERAS"
  
  propData$LocationGroup[propData$LocationGroup == "taman connaught, Kuala Lumpur"] <-"TAMAN CONNAUGHT"
  
  propData$LocationGroup[propData$LocationGroup == "Taman Desa, Kuala Lumpur"] <-"TAMAN DESA"
  propData$LocationGroup[propData$LocationGroup == "KL Eco City, Kuala Lumpur"] <-"TAMAN DESA"
  
  propData$LocationGroup[propData$LocationGroup == "Taman Ibukota, Kuala Lumpur"] <-"TAMAN SETAPAK"
  propData$LocationGroup[propData$LocationGroup == "Setapak, Kuala Lumpur"] <-"TAMAN SETAPAK"
  
  propData$LocationGroup[propData$LocationGroup == "TAMAN MELATI, Kuala Lumpur"] <-"FLAT TAMAN MELATI"
  propData$LocationGroup[propData$LocationGroup == "Taman Melawati, Kuala Lumpur"] <-"TAMAN MELATI"
  propData$LocationGroup[propData$LocationGroup == "Taman Sri Keramat, Kuala Lumpur"] <-"KERAMAT WANGSA"
  propData$LocationGroup[propData$LocationGroup == "Taman Tijani Ukay, Kuala Lumpur"] <-"SEKSYEN 10 WANGSA MAJU"
  
  propData$LocationGroup[propData$LocationGroup == "Taman Wangsa Permai, Kuala Lumpur"] <-"JALAN SUNGAI BESI"
  propData$LocationGroup[propData$LocationGroup == "Sungai Besi, Kuala Lumpur"] <-"JALAN SUNGAI BESI"
  
  propData$LocationGroup[propData$LocationGroup == "Titiwangsa, Kuala Lumpur"] <-"SETAPAK SELATAN"
  
  propData$LocationGroup[propData$LocationGroup == "Ukay Heights, Kuala Lumpur"] <-"TAMAN SETIAWANGSA"
  propData$LocationGroup[propData$LocationGroup == "Setiawangsa, Kuala Lumpur"] <-"TAMAN SETIAWANGSA"
  
  propData$LocationGroup[propData$LocationGroup == "Wangsa Maju, Kuala Lumpur"] <-"SEKSYEN 2 WANGSA MAJU"
  propData$LocationGroup[propData$LocationGroup == "Wangsa Melawati, Kuala Lumpur"] <-"TAMAN WANGSA MELAWATI"
  
  propData$LocationGroup[propData$LocationGroup == "Jalan Klang Lama (Old Klang Road), Kuala Lumpur"] <-"TAMAN SRI SENTOSA UTARA"
  
  propData$LocationGroup[propData$LocationGroup == "Bandar Damai Perdana, Kuala Lumpur"] <-"TAMAN LEN SEN"
  
  propData$LocationGroup[propData$LocationGroup == "SANTUARI PARK PANTAI, Kuala Lumpur"] <-"PANTAI DALAM"
  
  
  # check the locationGroup that has not been mapped
  notMapData <- propData$LocationGroup[-which(propData$LocationGroup %in% g_area_df$LocationGroup)]
  #notMapData
  
  # show the row without price
  propData[-which(propData$Price == ""), ]
  # show the na size
  propData[which(is.na(propData$Size)), ]
  # remove the row without price
  propData <- propData[!(is.na(propData$Price) | propData$Price==""), ]
  propData <- propData[!(is.na(propData$Size) | propData$Size==""), ]

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
  # remove na price
  propData <- propData[!(is.na(propData$Price) | propData$Price==""), ]
  # convert to numeric
  propData$Price <- as.numeric(propData$Price)
  # remove the prop price less than 100k and greater than 5mil, not realistic
  propData <- propData[propData$Price > 100000,]
  propData <- propData[propData$Price < 15000000,]
  
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
  # check if there na 
  propData$Size[is.na(propData$Size)]
  # remove the row without size
  propData <- propData[!(is.na(propData$Size) | propData$Size==""), ]
  propData$Size <- as.numeric(propData$Size)
  
  # remove the prop size less than 300 sqf and greater than 5000 sqf, not realistic
  propData <- propData[propData$Size > 300,]
  propData <- propData[propData$Size < 5000,]
  
  # check property type
  propData <- propData[!is.na(propData$Location),]
  row.names(propData) <- NULL
  
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
