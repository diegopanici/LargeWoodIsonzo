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
# Load UI components, making sure they don't return TRUE
ui_content <- local({
  source("UI.R", local = TRUE)
  # Make sure UI.R returns a UI element rather than TRUE
  # This assumes UI.R is defining a variable or function that returns the UI
  get("ui_content", envir = environment())
})

ui <- navbarPage("Instream large wood on the River Isonzo", id = 'nav',
                 tabPanel("Map", ui_content)
)

# Define the server that performs all necessary operations with proper scoping ----
server <- function(input, output, session) {
  # Create a proper environment for server code to run in
  local({
    # Make input, output, and session available to the sourced file
    source("Server.R", local = TRUE)
  }, envir = environment())
}

# Run the application ----
shinyApp(ui, server)
