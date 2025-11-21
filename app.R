# app.R
library(shiny)
library(leaflet)
library(sf)
library(raster)
library(ggplot2)
library(geojsonio)
library(RColorBrewer)
library(terra)
library(leafem)
library(dbscan)

options(shiny.maxRequestSize = 1000 * 1024^2)

# Load data
source("Global.R")

# Load UI
source("UI.R")
ui <- navbarPage("Instream large wood on the River Isonzo", id = 'nav',
                 tabPanel("Map", 
                         div(class="outer",
                             leafletOutput("map", height = "calc(100vh - 70px)")
                         )
                 )
)

# Define server
server <- function(input, output, session) {
  source("Server_function.R", local = environment())
}

# Run the application
shinyApp(ui, server)



