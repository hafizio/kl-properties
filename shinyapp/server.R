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
            # render the data frame that the first column is the average psf
            resultInPsf <- format(areaPriceData[,4],digits=2, nsmall=0, big.mark=",",small.mark=".", small.interval=3 )
        } else {
            # render the data frame that the first column is the average price
            resultInPrice <- format(areaPriceData[,2],digits=2, nsmall=0, big.mark=",",small.mark=".", small.interval=3 )
        }
    })
    updateLeafletScale <- reactive({
        if (inputView() == "Psf") {
            # render the data frame that the first column is the average psf
            areaPriceData[,4]
        } else {
            # render the data frame that the first column is the average price
            areaPriceData[,2]
        }
    })
    updateMaxRange <- reactive({
        if (inputView() == "Psf") {
            # render the data frame that the first column is the average psf
            c(0, g_max_psf_range)
        } else {
            # render the data frame that the first column is the average price
            c(0, g_max_price_range)
        }
    })
    getPrefix <- reactive({
        if (inputView() == "Psf") {
            # render the data frame that the first column is the average psf
            ""
        } else {
            # render the data frame that the first column is the average price
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
    # RENDERING 
    #
    # Render map
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
                        color = qpal(rescale(x = updateLeafletScale(), to = updateMaxRange(),  na.rm=TRUE))
            ) %>%
            setView(lat = 3.138951, lng = 101.694423, zoom = 12) %>%
            addLegend(
                "bottomleft",
                pal = qpal,
                values = updateMaxRange(),
                opacity = 0.7,
                labFormat = labelFormat(suffix = "", prefix=getPrefix()),
            )
    })
}

