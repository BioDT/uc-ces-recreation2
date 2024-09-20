reclassify_rasters <- function(cropped_rasters, raster_folder, persona_folder, persona_id) {
  # Initialize a list to store the modified raster objects
  modified_rasters <- list()

  # Construct the path to the CSV file in the persona folder
  csv_file <- paste0(persona_folder, "/", persona_id, ".csv") #csv_file <-  "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/output/Persona_Scores/CA_Test_04.csv"
  
  # Check if the CSV file exists
  if (!file.exists(csv_file)) {
    stop("CSV file not found in persona folder: ", csv_file)
  }
  
  sloped_raster<-"/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/FIPS_N/slope/FIPS_N_Slope.tif"
  
  # Load the CSV table
  table <- read.csv(csv_file) #
  
  # Ensure the relevant columns are numeric
  if (!is.numeric(table$Raster_Val)) {
    table$Raster_Val <- as.numeric(table$Raster_Val)
  }
  if (!is.numeric(table[[persona_id]])) {
    table[[persona_id]] <- as.numeric(table[[persona_id]])
  }
  
  # Loop through each raster file
  for (raster_file in names(cropped_rasters)) {
    # Check if the current raster is the slope raster
    if (grepl("FIPS_N_Slope", tolower(raster_file))) {
      # Load the slope raster from the cropped rasters list
      slope_raster <- cropped_rasters[[raster_file]]
      
      # Filter the CSV table for slope-specific reclassification data
      # Assume the slope-specific values have "slope" in the "Name" column
      slope_table <- table[grepl("FIPS_N_Slope", table$Name), ]
      
      # Ensure the slope-specific rows exist
      if (nrow(slope_table) == 0) {
        cat("No matching slope reclassification data found in CSV for raster", raster_file, ". Skipping...\n")
        next
      }
      
      # Define the slope value ranges and corresponding scores
      slope_df <- data.frame(
        group_val_min = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
        group_val_max = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
        score = slope_table[[persona_id]]  # Use the "persona_id" column for the slope reclassification
      )
      
      # Convert the data frame to a matrix for reclassification
      reclass_m <- data.matrix(slope_df)
      
      # Reclassify the slope raster using the slope-specific groups
      slope_raster <- reclassify(slope_raster, reclass_m)
      
      # Add the reclassified slope raster to the list
      modified_rasters[["slope"]] <- slope_raster
      
    } else {
      # Handle the general raster case (non-slope rasters)
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
  }
  
  # Return the modified rasters
  return(modified_rasters)
}