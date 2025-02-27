#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ##
##                  Creating a ShinyApp                        ##
##                         App.R                               ##
##        code by Diego Panici (d.panici@exeter.ac.uk)         ##
#################################################################

packages <- c("shiny", "leaflet", "sf", "raster", "ggplot2", "geojsonio", "ggiraph", "RColorBrewer", "terra", "leafem")
missing <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(missing)) install.packages(missing)

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

options(shiny.launch.browser = FALSE)  # Prevent browser launch issues
options(shiny.maxRequestSize = 1000 * 1024^2)  # Allow large files
setwd(getwd())  # Force working directory

setwd(dirname(sys.frame(1)$ofile))

print(getwd())  # Check the working directory
print(file.exists("Server.R"))  # TRUE if Server.R is found, FALSE otherwise
source("Server.R", local = TRUE)
print("Server.R successfully sourced!")


# Run global script containing all your relevant data ----
source("Global.R")

# Define UI for visualisation ----
source("UI.R")

ui <- navbarPage("Instream large wood on the River Isonzo", id = 'nav',
                 tabPanel("Map", 
                          div(class="outer",
                              leafletOutput("map", height = "calc(100vh - 70px)")
                          )
                 )
)

# Define the server that performs all necessary operations ----
server <- function(input, output, session) {
  print("Server.R is being sourced...")
  source("Server.R", local = TRUE)
  print("Server.R loaded.")
}


# Run the application ----
shinyApp(ui, server)
