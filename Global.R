#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ##
##                  Creating a ShinyApp                        ##
##                        Global.R                             ##
##        code by Diego Panici (d.panici@exeter.ac.uk)         ##
#################################################################

# G1 Load large wood, river, and bridge data ----
lw_points <- st_read("LW_Isonzo.shp")
river <- st_read("RiverIsonzo.shp")
bridges <- st_read("Bridges_Isonzo.shp")
clusters <- st_read("IsonzoClusters.shp")
nearestdist <- sf::st_read("NearestDistIsonzo.shp")

#Convert vectors to CRS 4326

lw_points <- st_transform(lw_points, crs = 4326)
river <- st_transform(river, crs = 4326)
bridges <- st_transform(bridges, crs = 4326)
#clusters <- st_transform(clusters, crs = 4326) #comment out if using dbscan
nearestdist <- st_transform(nearestdist, crs = 4326)

# Dynamically generate colors based on number of unique clusters

##Option 1 - using pre-defined clusters
 
#num_clusters <- length(unique(clusters$CLUSTER_ID))
#pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters), domain = clusters$CLUSTER_ID)

##Option 2: adding the clusters via dbscan, comment out if needs to be different

lw_points <- st_transform(lw_points, crs = 3857)
lw_coords <- st_coordinates(lw_points)
clusters <- dbscan(lw_coords, eps = 1000, minPts = 3)
lw_points$clusters <- as.factor(clusters$cluster)
# Reproject lw_points back to CRS 4326
lw_points <- st_transform(lw_points, crs = 4326)
num_clusters <- length(unique(lw_points$clusters))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters),domain = lw_points$clusters)


#Then add raster files
heatmap <- rast("heatmap.tif")
heatmap <- project(heatmap, "EPSG:4326")  # Project to WGS84
#heatmap<- raster(heatmap)


pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)), na.color = "transparent")



