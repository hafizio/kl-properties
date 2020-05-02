function(input, output, session) {

        # create the legend bins
    bins<-seq(from = 0, to = 100, by = 10)
    qpal <- colorNumeric(
        na.color = "white",
        palette = c("white", "orange", "red"),
        domain = c(0, 100)
    )
    
    # Render map
    output$map <- renderLeaflet({
        leaflet(g_geojson) %>%
            addTiles() %>%
            addPolygons(stroke = FALSE,
                        smoothFactor = 0.3,
                        fillOpacity = 0.5,
                        label = ,# paste(g_country_list, ":", df_pop_ratio()[,1]),
                        color = # qpal(rescale(x = df_pop_ratio()[,1], to = c(0, 100),  na.rm=TRUE))
            ) %>%
            setView(lat = 3.138951, lng = 101.694423, zoom = 12) %>%
            addLegend(
                "bottomleft",
                pal = qpal,
                values = c(0,100),
                opacity = 0.7,
                labFormat = labelFormat(suffix = "%"),
            )
    })
}

