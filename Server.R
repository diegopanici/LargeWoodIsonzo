#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ##
##                  Creating a ShinyApp                        ##
##                      Server.R                               ##
##        code by Diego Panici (d.panici@exeter.ac.uk)         ##
#################################################################


# S1 Render leaflet map ----
output$map <- renderLeaflet({
  leaflet() %>%
    setView(lng=13.533545, lat=45.850065, zoom=11.3) %>%
    addProviderTiles(providers$OpenStreetMap, group = "Colour") %>%
    addPolylines(data = river, color = "blue", weight = 2, opacity = 0.8, group = "River") %>%
    addCircles(data = bridges, color = "black", fillColor="purple", fillOpacity=0.8, 
               weight = 2, radius = 50, group = "Bridges") %>%
    addPolylines(data = nearestdist, color = "black", weight = 2, opacity = 0.8, 
                 group = "Nearest distance") %>%
    addRasterImage(heatmap, colors = pal_heatmap, opacity = 0.7, group = "Heatmap") %>%
    addImageQuery(
      heatmap,
      layerId = "Heatmap",
      prefix = "Value: ",
      digits = 2,
      position = "topright",
      type = "mousemove",  # Show values on mouse movement
      options = queryOptions(position = "topright"),  # Remove the TRUE text
      group = "Heatmap"
    ) %>%
    addLayersControl(
      baseGroups = c("Colour"),
      overlayGroups = c("River", "Bridges", "Nearest distance", "Large Wood", "Heatmap"),
      options = layersControlOptions(collapsed = TRUE)
    )
})
  # Add popups for large wood points
  observe({
    leafletProxy("map") %>%
      clearMarkers() %>%
      addCircleMarkers(data = clusters, fillColor = ~pal_clusters(CLUSTER_ID), color = "black", 
                       weight = 1, radius = 5, stroke = TRUE, fillOpacity = 0.8,
                       popup = ~paste("<b>Type:</b>", Type, "<br><b>Imagery used:</b>", Imagery, "<br><b>Cluster ID:</b>", CLUSTER_ID),
                       group = "Large Wood") %>%
    addCircleMarkers(data = bridges, color = "black", radius = 3, stroke = TRUE, fillOpacity = 0.8,
                     popup = ~paste("<b>Bridge:</b>", Name),
                     group = "Bridges")
  })
  