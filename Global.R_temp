#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ##
##                  Creating a ShinyApp                        ##
##                        Global.R                             ##
##        code by Diego Panici (d.panici@exeter.ac.uk)         ##
#################################################################

# Global.R with diagnostics

cat("Starting Global.R execution...\n")

# Check working directory
cat("Working directory:", getwd(), "\n")

# List files in current directory
cat("Files in directory:\n")
print(list.files())

# Try to load files with error handling
tryCatch({
  cat("Loading LW_Isonzo.shp...\n")
  lw_points <- st_read("LW_Isonzo.shp")
  cat("LW_Isonzo.shp loaded successfully\n")
}, error = function(e) {
  cat("ERROR loading LW_Isonzo.shp:", conditionMessage(e), "\n")
  lw_points <<- NULL
})

tryCatch({
  cat("Loading RiverIsonzo.shp...\n")
  river <- st_read("RiverIsonzo.shp")
  cat("RiverIsonzo.shp loaded successfully\n")
}, error = function(e) {
  cat("ERROR loading RiverIsonzo.shp:", conditionMessage(e), "\n")
  river <<- NULL
})

tryCatch({
  cat("Loading Bridges_Isonzo.shp...\n")
  bridges <- st_read("Bridges_Isonzo.shp")
  cat("Bridges_Isonzo.shp loaded successfully\n")
}, error = function(e) {
  cat("ERROR loading Bridges_Isonzo.shp:", conditionMessage(e), "\n")
  bridges <<- NULL
})

tryCatch({
  cat("Loading IsonzoClusters.shp...\n")
  clusters <- st_read("IsonzoClusters.shp")
  cat("IsonzoClusters.shp loaded successfully\n")
}, error = function(e) {
  cat("ERROR loading IsonzoClusters.shp:", conditionMessage(e), "\n")
  clusters <<- NULL
})

tryCatch({
  cat("Loading NearestDistIsonzo.shp...\n")
  nearestdist <- st_read("NearestDistIsonzo.shp")
  cat("NearestDistIsonzo.shp loaded successfully\n")
}, error = function(e) {
  cat("ERROR loading NearestDistIsonzo.shp:", conditionMessage(e), "\n")
  nearestdist <<- NULL
})

# Transform CRS only if objects exist
if (!is.null(lw_points)) lw_points <- st_transform(lw_points, crs = 4326)
if (!is.null(river)) river <- st_transform(river, crs = 4326)
if (!is.null(bridges)) bridges <- st_transform(bridges, crs = 4326)
if (!is.null(clusters)) clusters <- st_transform(clusters, crs = 4326)
if (!is.null(nearestdist)) nearestdist <- st_transform(nearestdist, crs = 4326)

# Color palette
if (!is.null(clusters)) {
  num_clusters <- length(unique(clusters$CLUSTER_ID))
  pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters), 
                              domain = clusters$CLUSTER_ID)
  cat("Cluster palette created\n")
}

# Heatmap
tryCatch({
  cat("Loading Heatmap_lowres.tif...\n")
  heatmap <- rast("Heatmap_lowres.tif")
  heatmap <- project(heatmap, "EPSG:4326")
  heatmap <- raster(heatmap)
  pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)), 
                              na.color = "transparent")
  cat("Heatmap loaded successfully\n")
}, error = function(e) {
  cat("ERROR loading heatmap:", conditionMessage(e), "\n")
  heatmap <<- NULL
})

cat("Global.R execution completed\n")
cat("Objects created:\n")
cat("- lw_points:", !is.null(lw_points), "\n")
cat("- river:", !is.null(river), "\n")
cat("- bridges:", !is.null(bridges), "\n")
cat("- clusters:", !is.null(clusters), "\n")
cat("- nearestdist:", !is.null(nearestdist), "\n")
cat("- heatmap:", !is.null(heatmap), "\n")

