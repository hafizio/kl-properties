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
            resultInPsf <- format(areaPriceData[,4],digits=2, nsmall=0, big.mark=",",small.mark=".", small.interval=3 )
        } else {
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
                        label = paste(g_areaList, " : ", getPrefix() , updateLeaflet()),
                        color = qpal(rescale(
                                        x = updateLeafletScale(),
                                        to = c(0, g_max_price_range), 
                                        na.rm=TRUE
                                        )
                                     )
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
                labFormat = labelFormat(suffix = "", prefix=getPrefix()),
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
    
    
}

