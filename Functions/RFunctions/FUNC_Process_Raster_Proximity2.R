process_raster_proximity <- function(input_raster, max_distance) {
  # Create empty list to store output rasters
  proximity_rasters <- list()
  
  # Check if all values in the raster are zeros
  if (all(values(input_raster) == 0)) {
    message("RasterLayer '", names(input_raster), "' has no non-zero values.")
    return(NULL)
  } else{
    # Create a sequence of score values
    score_values <- unique(terra::values(input_raster))
    score_values <- score_values[!is.na(score_values)]
    
    # Loop over the score values
    for (value in score_values) {
      # Create a subset raster for the current value
      subset_raster <- input_raster
      subset_raster[subset_raster != value] <- NA
      
      # Check if subset raster contains any non-NA cells
      if (!all(is.na(terra::values(subset_raster)))) {
        # Create the proximity raster
        proximity_raster <- terra::distance(subset_raster)
        
        # Set cells outside the maximum distance to NA
        proximity_raster[proximity_raster > max_distance] <- NA
        
        # Add the proximity raster to the list
        proximity_rasters[[as.character(value)]] <- proximity_raster
      } else {
        message("No non-NA cells found for value ", value, " in raster '", names(input_raster), "'. Skipping.")
      }
    }
  }
  
  
  # Return the proximity rasters
  return(terra::rast(proximity_rasters))
}






# process_raster_proximity <- function(input_raster, max_distance) {
#   # Check if all values in the raster are zeros
#   if (all(values(input_raster) == 0)) {
#     message("RasterLayer '", names(input_raster), "' has no non-zero values.")
#     return(NULL)  # Return NULL to signify no proximity raster calculated
#   }
#   
#   # Create a sequence of score values
#   score_values <- unique(getValues(input_raster))
#   score_values <- score_values[!is.na(score_values)]
#   
#   # Create empty list to store output rasters
#   proximity_rasters <- list()
#   
#   # Loop over the score values
#   for (value in score_values) {
#     # Create a subset raster for the current value
#     subset_raster <- input_raster
#     subset_raster[subset_raster != value] <- NA
#     
#     # Check if subset raster contains any non-NA cells
#     if (!all(is.na(getValues(subset_raster)))) {
#       # Create the proximity raster
#       proximity_raster <- distance(subset_raster, fun = function(x) !is.na(x), units = "m")
#       
#       # Set cells outside the maximum distance to NA
#       proximity_raster[proximity_raster > max_distance] <- NA
#       
#       # Add the proximity raster to the list
#       proximity_rasters[[as.character(value)]] <- proximity_raster
#     } else {
#       message("No non-NA cells found for value ", value, " in raster '", names(input_raster), "'. Skipping.")
#     }
#   }
#   
#   # Return the proximity rasters
#   return(proximity_rasters)
# }
