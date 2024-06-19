# Modify the list of rasters to skip those without NA cells
process_rasters <- function(raster_list, max_distance) {
  processed_rasters <- lapply(raster_list, function(raster) {
    process_raster_proximity(raster, max_distance)
  })
  
  # Filter out NULL elements (skipped rasters)
  processed_rasters <- processed_rasters[sapply(processed_rasters, function(x) !is.null(x))]
  
  return(processed_rasters)
}
