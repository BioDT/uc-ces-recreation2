crop_rasters_by_mask <- function(raster_folder, Raster_Empty) {
  # Load required libraries
  library(raster)
  
  # Get a list of all raster files in the directory
  raster_files <- list.files(raster_folder, pattern=".tif$", full.names = TRUE)
  
  # Initialize a list to store the modified raster objects
  cropped_rasters <- list()
  
  # Loop through each raster file
  for (file in raster_files) {
    # Load the raster file
    r <- raster(file)
    
    # Crop the raster using the mask layer
    cropped_raster <- crop(r, Raster_Empty)
    
    # Store the cropped raster in the list
    cropped_rasters[[basename(file)]] <- cropped_raster
  }
  
  # Return the modified rasters
  return(cropped_rasters)
}