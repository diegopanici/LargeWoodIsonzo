#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ##
##                  Creating a ShinyApp                        ##
##                         UI.R                                ##
##        code by Diego Panici (d.panici@exeter.ac.uk)         ##
#################################################################


div(class="outer",
                  leafletOutput("map", height = "calc(100vh - 70px)")
)
