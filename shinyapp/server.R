function(input, output, session) {

    g_max_range = 200000 # range price from 0 to 2mil
    
    # create the legend bins
    bins<-seq(from = 0, to = g_max_range, by = 10)
    qpal <- colorNumeric(
        na.color = "white",
        palette = c("white", "orange", "red"),
        domain = c(0, g_max_range)
    )
    
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
                        label = paste(g_areaList, ":", areaPriceData[,-1]),
                        color = qpal(rescale(x = areaPriceData[,-1], to = c(0, g_max_range),  na.rm=TRUE))
            ) %>%
            setView(lat = 3.138951, lng = 101.694423, zoom = 12) %>%
            addLegend(
                "bottomleft",
                pal = qpal,
                values = c(0,g_max_range),
                opacity = 0.7,
                labFormat = labelFormat(suffix = "", prefix="RM"),
            )
    })
}

