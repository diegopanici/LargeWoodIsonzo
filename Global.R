#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ##
##                  Creating a ShinyApp                        ##
##                        Global.R                             ##
##        code by Diego Panici (d.panici@exeter.ac.uk)         ##
#################################################################


# G1 Load large wood, river, and bridge data ----
lw_points <- sf::st_read("LW_Isonzo.shp")
river <- sf::st_read("RiverIsonzo.shp")
bridges <- sf::st_read("Bridges_Isonzo.shp")
clusters <- sf::st_read("IsonzoClusters.shp")
nearestdist <- sf::st_read("NearestDistIsonzo.shp")

#Convert vectors to CRS 4326

lw_points <- st_transform(lw_points, crs = 4326)
river <- st_transform(river, crs = 4326)
bridges <- st_transform(bridges, crs = 4326)
clusters <- st_transform(clusters, crs = 4326)
nearestdist <- st_transform(nearestdist, crs = 4326)

# Dynamically generate colors based on number of unique clusters
num_clusters <- length(unique(clusters$CLUSTER_ID))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters), domain = clusters$CLUSTER_ID)


heatmap <- rast("Heatmap.tif")
heatmap <- project(heatmap, "EPSG:4326")  # Project to WGS84
heatmap<- raster(heatmap)


pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)), na.color = "transparent")
