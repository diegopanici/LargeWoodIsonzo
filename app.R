library(shiny)
library(leaflet)
library(sf)
library(raster)
library(ggplot2)
library(geojsonio)
library(ggiraph)
library(RColorBrewer)
library(terra)
library(leafem)

options(shiny.maxRequestSize = 1000 * 1024^2)

# Load data directly in App.R (not in separate Global.R)
lw_points <- st_read("LW_Isonzo.shp")
river <- st_read("RiverIsonzo.shp")
bridges <- st_read("Bridges_Isonzo.shp")
clusters <- st_read("IsonzoClusters.shp")
nearestdist <- st_read("NearestDistIsonzo.shp")

# Convert vectors to CRS 4326
lw_points <- st_transform(lw_points, crs = 4326)
river <- st_transform(river, crs = 4326)
bridges <- st_transform(bridges, crs = 4326)
clusters <- st_transform(clusters, crs = 4326)
nearestdist <- st_transform(nearestdist, crs = 4326)

# Dynamically generate colors based on number of unique clusters
num_clusters <- length(unique(clusters$CLUSTER_ID))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters), 
                            domain = clusters$CLUSTER_ID)

# Load heatmap
heatmap <- rast("Heatmap_lowres.tif")
heatmap <- project(heatmap, "EPSG:4326")
heatmap <- raster(heatmap)

pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)), 
                            na.color = "transparent")

# Define UI
ui <- navbarPage("Instream large wood on the River Isonzo", id = 'nav',
                 tabPanel("Map", 
                         div(class="outer",
                             leafletOutput("map", height = "calc(100vh - 70px)")
                         )
                 )
)

# Define server
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(lng=13.533545, lat=45.850065, zoom=11.3) %>%
      addProviderTiles(providers$OpenStreetMap, group = "Colour") %>%
      addPolylines(data = river, color = "blue", weight = 2, opacity = 0.8, group = "River") %>%
      addPolylines(data = nearestdist, color = "black", weight = 2, opacity = 0.8, 
                   group = "Nearest distance") %>%
      addRasterImage(heatmap, colors = pal_heatmap, opacity = 0.7, group = "Heatmap", 
                     layerId = "Heatmap") %>%
      addImageQuery(
        heatmap,
        layerId = "Heatmap",
        prefix = "Value: ",
        digits = 2,
        position = "topright",
        type = "mousemove",
        options = queryOptions(position = "topright"),
        group = "Heatmap"
      ) %>%
      addCircleMarkers(data = clusters, 
                       fillColor = ~pal_clusters(CLUSTER_ID), 
                       color = "black", 
                       weight = 1, 
                       radius = 5, 
                       stroke = TRUE, 
                       fillOpacity = 0.8,
                       popup = ~paste("<b>Type:</b>", Type, 
                                      "<br><b>Imagery used:</b>", Imagery, 
                                      "<br><b>Cluster ID:</b>", CLUSTER_ID),
                       group = "Large Wood") %>%
      addCircleMarkers(data = bridges, 
                       color = "black", 
                       radius = 3, 
                       stroke = TRUE, 
                       fillOpacity = 0.8,
                       popup = ~paste("<b>Bridge:</b>", Name),
                       group = "Bridges") %>%
      addLayersControl(
        baseGroups = c("Colour"),
        overlayGroups = c("River", "Bridges", "Nearest distance", "Large Wood", "Heatmap"),
        options = layersControlOptions(collapsed = TRUE)
      )
  })
}

# Run the application
shinyApp(ui, server)
