source("readData.R")
source("crawlUrl.R")

function(input, output, session) {
    
    #
    # LOCAL CONSTANT
    #
    g_max_price_range = 2000000 # range price from 0 to 2mil
    g_max_psf_range = 2000 # range psf from 0 to 2k
    
    
    #
    # REACTIVE METHOD
    #
    inputView = reactive({
        input$selected_view
    })
    
    updateLeaflet <- reactive({
        if (inputView() == "Psf") {
          print("im here --> updateLeaflet | psf")
            resultInPsf <- format(areaPriceData[,4],digits=2, nsmall=0, big.mark=",",small.mark=".", small.interval=3 )
        } else {
          print("im here --> updateLeaflet | price")
            resultInPrice <- format(areaPriceData[,2],digits=2, nsmall=0, big.mark=",",small.mark=".", small.interval=3 )
        }
    })
    updateLeafletScale <- reactive({
        if (inputView() == "Psf") {
            areaPriceData[,4]
        } else {
            areaPriceData[,2]
        }
    })
    getPrefix <- reactive({
        if (inputView() == "Psf") {
            ""
        } else {
            "RM"
        }
    })
    getSuffix <- reactive({
      if (inputView() == "Psf") {
        "psf"
      }
    })
    
    
    
    
    # create the legend bins
    qpal <- colorNumeric(
        na.color = "white",
        palette = c("Green", "Yellow", "Red"),
        domain = c(0, g_max_price_range)
    )
    
    #
    # RENDERING MAP
    #
    output$map <- renderLeaflet({
        leaflet(g_geojson) %>%
            addTiles() %>%
            addPolygons(stroke = F,
                        smoothFactor = 0.3,
                        fillOpacity = 0.5,
                        # display by the price first...
                        # TODO : then we move to display the psf
                        # TODO : maybe interactive recalculate by select option prop_price or psf
                        label = paste(g_areaList, " : ", getPrefix() , updateLeaflet(), getSuffix()),
                        color = qpal(rescale(
                                        x = updateLeafletScale(),
                                        to = c(0, g_max_price_range), 
                                        na.rm=TRUE
                                        )
                                     )
            ) %>%
            # show subway lines
            # TODO : somehow the subway line display not consistent!!!
            # addPolylines(data = subwayLines, 
            #              weight = 3, 
            #              color = "Black", 
            #              group = c_controlGroup) %>%
            # show buildings 
            # addPolylines(data = buildings, weight = 3, 
            #             color = "Purple", group = c_controlGroup) %>%
            # show School 
            addCircleMarkers(data = school,
                             group = "School",
                             color = "#382b82", 
                             label = school$name,  
                             radius = 5, 
                             stroke = FALSE, fillOpacity = .8) %>% 
            # show Hospital 
            addCircleMarkers(data = hospital,
                             group = "Hospital",
                             color = "#5923a9", 
                             label = hospital$name,  
                             radius = 5, 
                             stroke = FALSE, fillOpacity = .9) %>%
            # show university 
            addCircleMarkers(data = university,
                             group = "University",
                             color = "#006b4f", 
                             label = university$name,  
                             radius = 5, 
                             stroke = FALSE, fillOpacity = .9) %>%
            # show atm 
            addCircleMarkers(data = atm,
                             group = "ATM",
                             color = "#00e5ff", 
                             label = atm$name,  
                             radius = 5, 
                             stroke = FALSE, fillOpacity = .9) %>%
            # show police 
            addCircleMarkers(data = police,
                             group = "Police Station",
                             color = "#d770fa", 
                             label = police$name,  
                             radius = 5, 
                             stroke = FALSE, fillOpacity = .9) %>%
            # show fuel 
            addCircleMarkers(data = fuel,
                             group = "Fuel Station",
                             color = "#fb5050", 
                             label = fuel$name,  
                             radius = 5, 
                             stroke = FALSE, fillOpacity = .9) %>%
            # show control group
            leaflet::hideGroup(
                c_controlGroup
            ) %>% 
            addLayersControl(
                overlayGroups = c_controlGroup
            ) %>%
            setView(lat = 3.138951, lng = 101.694423, zoom = 12) %>%
            addLegend(
                "bottomleft",
                pal = colorNumeric(
                    na.color = "white",
                    palette = c("Green", "Yellow", "Red"),
                    domain = updateLeafletScale()
                ),
                values = updateLeafletScale(),
                opacity = 0.7,
                labFormat = labelFormat(suffix = getSuffix(), prefix=getPrefix()),
            )
    })
    
    #
    # RENDERING TABLE
    #
    output$rawDataTable <- renderDataTable(g_oriPropData)
    
    # format for display 
    displayTable <- areaPriceData
    displayTable$MeanPrice <- format(displayTable$MeanPrice,digits=2, nsmall=0, big.mark=",",small.mark=".", small.interval=3 )
    displayTable$MeanSize <- format(displayTable$MeanSize,digits=2, nsmall=0, big.mark=",",small.mark=".", small.interval=3 )
    displayTable$psf <- format(displayTable$psf,digits=2, nsmall=0, big.mark=",",small.mark=".", small.interval=3 )
    
    output$processedDataTable <- renderDataTable(displayTable)
    
    
    #
    # RENDERING WORDCLOUD2
    #
    processText <- function(topicUrl, lastPost) {
      # compile the url of pages
      topicUrl <- paste(topicUrl, "/+", sep="")
      resultText <- lapply(paste0(rep(topicUrl), 
                                  seq(0,lastPost,20)),
                           f_readpage)
      f_cleanText(resultText)
    }
    
    output$topicTitle <- renderText(f_readTitle(input$topicUrl))
    
    output$wc2 <- wordcloud2::renderWordcloud2({
      wordcloud2::wordcloud2(processText(input$topicUrl, input$lastPost), size=1.6, color='random-light', backgroundColor="black")
    })
    
}