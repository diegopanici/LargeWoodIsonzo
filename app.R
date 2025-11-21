# Load packages ----
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

# Run global script containing all your relevant data ----
source("Global.R")

# Define UI for visualisation ----
ui <- navbarPage("Instream large wood on the River Isonzo", id = 'nav',
                 tabPanel("Map", 
                         div(class="outer",
                             leafletOutput("map", height = "calc(100vh - 70px)")
                         )
                 )
)

# Define the server that performs all necessary operations ----
server <- function(input, output, session) {
  
  cat("Server function started\n")
  cat("Checking objects in server environment:\n")
  cat("- river exists:", exists("river"), "\n")
  cat("- bridges exists:", exists("bridges"), "\n")
  cat("- clusters exists:", exists("clusters"), "\n")
  cat("- heatmap exists:", exists("heatmap"), "\n")
  
  # S1 Render leaflet map ----
  output$map <- renderLeaflet({
    cat("renderLeaflet called\n")
    
    # Start with basic map
    m <- leaflet() %>%
      setView(lng=13.533545, lat=45.850065, zoom=11.3) %>%
      addProviderTiles(providers$OpenStreetMap, group = "Colour")
    
    cat("Base map created\n")
    
    # Add layers conditionally
    if (exists("river") && !is.null(river)) {
      m <- m %>% addPolylines(data = river, color = "blue", weight = 2, opacity = 0.8, group = "River")
      cat("River layer added\n")
    }
    
    if (exists("bridges") && !is.null(bridges)) {
      m <- m %>% addCircles(data = bridges, color = "black", fillColor="purple", 
                            fillOpacity=0.8, weight = 2, radius = 50, group = "Bridges")
      cat("Bridges layer added\n")
    }
    
    if (exists("nearestdist") && !is.null(nearestdist)) {
      m <- m %>% addPolylines(data = nearestdist, color = "black", weight = 2, 
                              opacity = 0.8, group = "Nearest distance")
      cat("Nearest distance layer added\n")
    }
    
    if (exists("heatmap") && !is.null(heatmap)) {
      tryCatch({
        m <- m %>% addRasterImage(heatmap, colors = pal_heatmap, opacity = 0.7, group = "Heatmap")
        cat("Heatmap layer added\n")
      }, error = function(e) {
        cat("ERROR adding heatmap:", conditionMessage(e), "\n")
      })
    }
    
    if (exists("clusters") && !is.null(clusters)) {
      m <- m %>% addCircleMarkers(data = clusters, 
                                  fillColor = ~pal_clusters(CLUSTER_ID), 
                                  color = "black", 
                                  weight = 1, 
                                  radius = 5, 
                                  stroke = TRUE, 
                                  fillOpacity = 0.8,
                                  popup = ~paste("<b>Type:</b>", Type, 
                                                 "<br><b>Imagery used:</b>", Imagery, 
                                                 "<br><b>Cluster ID:</b>", CLUSTER_ID),
                                  group = "Large Wood")
      cat("Clusters layer added\n")
    }
    
    m <- m %>% addLayersControl(
      baseGroups = c("Colour"),
      overlayGroups = c("River", "Bridges", "Nearest distance", "Large Wood", "Heatmap"),
      options = layersControlOptions(collapsed = TRUE)
    )
    
    cat("Map rendering complete\n")
    return(m)
  })
}
# Run the application ----
shinyApp(ui, server)




