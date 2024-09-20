reclassify_rasters <- function(cropped_rasters, raster_folder, persona_folder, persona_id) {
  # Initialize a list to store the modified raster objects
  modified_rasters <- list()
  
  # Construct the path to the CSV file (assuming a fixed CSV filename)
  csv_file <- paste0(persona_folder, "/", persona_id, ".csv")
  
  # Check if the CSV file exists
  if (!file.exists(csv_file)) {
    stop("CSV file not found in persona folder: ", csv_file)
  }
  
  # Load the CSV table
  table <- read.csv(csv_file)
  
  # Ensure the relevant columns are numeric
  if (!is.numeric(table$Raster_Val)) {
    table$Raster_Val <- as.numeric(table$Raster_Val)
  }
  if (!is.numeric(table[[persona_id]])) {
    table[[persona_id]] <- as.numeric(table[[persona_id]])
  }
  
  # Loop through each raster file
  for (raster_file in names(cropped_rasters)) {
    # Get the cropped raster object
    r <- cropped_rasters[[raster_file]]
    
    # Extract the base filename from the raster file (remove .tif and suffix after "_")
    base_name <- gsub("(_\\d+)?\\.tif$", "", raster_file)
    
    # Filter the CSV table to get relevant rows for the current raster
    raster_table <- table[grepl(paste0("^", base_name, "_?\\d*$"), table$Name), ]
    
    # Check if there are matching rows
    if (nrow(raster_table) == 0) {
      cat("No matching reclassification data found in CSV for raster", raster_file, ". Skipping...\n")
      next
    }
    
    # Reclassify raster values based on the filtered CSV table
    r[] <- raster_table[[persona_id]][match(getValues(r), raster_table$Raster_Val)]
    
    # Set NA values to 0 (or some other value if needed)
    r[is.na(r)] <- 0
    
    # Add the modified raster object to the list
    modified_rasters[[raster_file]] <- r
  }
  
  # Return the modified rasters
  return(modified_rasters)
}