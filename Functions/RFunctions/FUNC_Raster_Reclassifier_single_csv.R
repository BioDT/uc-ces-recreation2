#step 3: make it faster
reclassify_rasters <- function(cropped_rasters, raster_folder, table, persona_id) {


    if (!is.null(table)) {
        # Ensure the relevant columns are numeric
        table$Raster_Val <- as.numeric(table$Raster_Val)
        table[[persona_id]] <- as.numeric(table[[persona_id]])

        #Loop through each layer of the spatrast
        for (alayer in seq_along(names(cropped_rasters))) {

            #get the name
            name_l <- names(cropped_rasters)[alayer]

            # Filter the table to get relevant rows for the current raster
            raster_table <- table[grepl(
                paste0("^", name_l, "_?\\d*$"),
                table$Name
            ),
                ]

            # Check if there are no matching rows, if so, skip
            if (nrow(raster_table) ==
                0) {
                cat(
                  "No matching reclassification data found in CSV for raster", raster_file,
                  ". Skipping...\n"
              )
                next
            }

            #make a lookup table that specifies what to substitute with what
            lookup <- setNames(raster_table[, persona_id], raster_table$Raster_Val)

            #replace values
            terra::values(cropped_rasters[[name_l]]) <- lookup[match(
                terra::values(cropped_rasters[[name_l]]),
                as.numeric(names(lookup))
            )]
            terra::values(cropped_rasters[[name_l]])[is.na(terra::values(cropped_rasters[[name_l]]))] <- 0  # Set NA values to 0
        }

        # Return the modified rasters
        return(cropped_rasters)
    }
}


# reclassify_rasters_2 <- function(cropped_rasters, raster_folder, table,persona_id) {
#   if (!is.null(table)){
#     # Ensure the relevant columns are numeric
#     table$Raster_Val <- as.numeric(table$Raster_Val)
#     table[[persona_id]] <- as.numeric(table[[persona_id]])
# 
#     
#     
#     #Loop through each layer of the spatrast
#     for (alayer in seq_along(names(cropped_rasters))){
#       
#       #get the name
#       name_l <- names(cropped_rasters)[alayer]
#       
#       # Filter the table to get relevant rows for the current raster
#       raster_table <- subset(table, grepl(paste0('^', name_l, '_?\\\\\\\\\\\\\\\\d*$'), table$Name))
#       
#       # Check if there are no matching rows, if so, skip
#       if (nrow(raster_table) == 0) {
#         cat('No matching reclassification data found in CSV for raster', raster_file, '. Skipping...\\\\\\\\n')
#         next
#       }
#       reclass_matrix <- as.matrix(raster_table[, c('Raster_Val', persona_id)])
#       reclassified_raster <- terra::classify(cropped_rasters[[name_l]], rcl = reclass_matrix, right = NA)
#       
#       # Replace NA values with 0 for consistency
#       cropped_rasters[[name_l]] <- terra::ifel(is.na(reclassified_raster), 0, reclassified_raster)
# 
#     }
#     
#     # Return the modified rasters
#     return(cropped_rasters)
#   }
# }


# reclassify_rasters_par <- function(cropped_rasters, raster_folder, table,persona_id, num_cores) {
#   
#   
#   if (isTruthy(table)){
#     # Ensure the relevant columns are numeric
#     table$Raster_Val <- as.numeric(table$Raster_Val)
#     table[[persona_id]] <- as.numeric(table[[persona_id]])
#     
#     lookup_tables <- lapply(names(cropped_rasters), function(raster_name) {
#       raster_table <- table[grepl(paste0('^', raster_name, '_?\\\\\\\\\\\\\\\\d*$'), table$Name), ]
#       setNames(raster_table[[persona_id]], raster_table$Raster_Val)
#     })
#     
#     # Convert SpatRaster objects in `cropped_rasters` to raster::Raster objects
#     cropped_rasters <- lapply(cropped_rasters, function(spat_raster) {
#       raster::raster(spat_raster)
#     })
#     
#     # Parallelize the reclassification for each raster layer
#     cropped_rasters <- parallel::mclapply(
#       seq_along(cropped_rasters),  # Use index for easier reference
#       function(i) {
#         
#         raster_layer <- cropped_rasters[[i]]
#         lookup       <- lookup_tables[[i]]
#         
#         vals <- raster::getValues(raster_layer)
#         if (is.null(vals)) return(raster_layer)
#         
#         #replace values
#         reclassified_values <- lookup[as.character(vals)]
#         reclassified_values[is.na(reclassified_values)] <- 0  # Set NA to 0
#         raster::setValues(raster_layer, reclassified_values)
#         
#         return(raster_layer)
#       },
#       mc.cores = num_cores
#     )
#     
#     # Return the modified rasters as a spatrast
#     cropped_rasters <-  terra::rast(raster::stack(cropped_rasters))
#     return(cropped_rasters)
#   }
# }


# replace_raster_values <- function(raster_layer, lookup) {
#   # Extract raster values
#   values <- terra::values(raster_layer)
#   
#   # Replace values based on the lookup table
#   values <- lookup[match(values, as.numeric(names(lookup)))]
#   
#   # Set NA values to 0
#   values[is.na(values)] <- 0
#   
#   # Assign modified values back to the raster
#   terra::values(raster_layer) <- values
#   return(raster_layer)
# }
# 
# reclassify_rasters_par2 <- function(cropped_rasters, raster_folder, table,persona_id) {
#   
#   
#   if (isTruthy(table)){
#     # Ensure the relevant columns are numeric
#     table$Raster_Val <- as.numeric(table$Raster_Val)
#     table[[persona_id]] <- as.numeric(table[[persona_id]])
#     
# 
#     # Loop through each layer of the spatrast
#     for (alayer in seq_along(names(cropped_rasters))) {
#       # Get the layer name
#       name_l <- names(cropped_rasters)[alayer]
#       
#       # Filter the table to get relevant rows for the current raster layer
#       raster_table <- table[grepl(paste0('^', name_l, '_?\\\\\\\\\\\\\\\\d*$'), table$Name), ]
#       
#       # Skip if no matching reclassification data is found
#       if (nrow(raster_table) == 0) {
#         cat('No matching reclassification data found for raster', name_l, '. Skipping...\\\\\\\\n')
#         next
#       }
#       
#       # Create lookup table that specifies what to substitute with what
#       lookup <- stats::setNames(raster_table[[persona_id]], raster_table$Raster_Val)
#       
#       # Use helper function to replace raster values
#       cropped_rasters[[name_l]] <- replace_raster_values(cropped_rasters[[name_l]], lookup)
#     }
#     # Return the modified rasters
#     return(cropped_rasters)
#   }
# }



# # #step 2: use a spatrast
# reclassify_rasters_orig <- function(cropped_rasters, raster_folder, persona_folder, persona_id) {
# 
#   # Construct the path to the CSV file (assuming a fixed CSV filename)
#   csv_file <- paste0(persona_folder, '/', persona_id, '.csv')
# 
#   # Check if the CSV file exists
#   if (!file.exists(csv_file)) {
#     stop('CSV file not found in persona folder: ', csv_file)
#   }
# 
#   # Load the CSV table
#   table <- read.csv(csv_file)
# 
#   # Ensure the relevant columns are numeric
#   if (!is.numeric(table$Raster_Val)) {
#     table$Raster_Val <- as.numeric(table$Raster_Val)
#   }
#   if (!is.numeric(table[[persona_id]])) {
#     table[[persona_id]] <- as.numeric(table[[persona_id]])
#   }
# 
#   #Loop through each raster file
#   for (alayer in 1:length(names(cropped_rasters))){
#     # Filter the CSV table to get relevant rows for the current raster
#     raster_table <- table[grepl(paste0('^', names(cropped_rasters)[alayer], '_?\\\\\\\\\\\\\\\\d*$'), table$Name), ]
#     # Check if there are matching rows
#     if (nrow(raster_table) == 0) {
#       cat('No matching reclassification data found in CSV for raster', raster_file, '. Skipping...\\\\\\\\n')
#       next
#     }
# 
#     # Extract layer values once
#     layer_values <- terra::values(cropped_rasters[[names(cropped_rasters)[alayer]]])
#     # Reclassify raster values based on the filtered CSV table
#     matched_values <- raster_table[[persona_id]][match(layer_values, raster_table$Raster_Val)]
#     # Set NA values to 0 (or some other value if needed)
#     matched_values[is.na(matched_values)] <- 0
#     # save the new values
#     cropped_rasters[[names(cropped_rasters)[alayer]]] <- matched_values
#   }
# 
#   # Return the modified rasters
#   return(cropped_rasters)
# }


# reclassify_rasters <- function(cropped_rasters, raster_folder, persona_folder, persona_id) {
#   # Initialize a list to store the modified raster objects
#   modified_rasters <- list()
#   
#   # Construct the path to the CSV file (assuming a fixed CSV filename)
#   csv_file <- paste0(persona_folder, '/', persona_id, '.csv')
#   
#   # Check if the CSV file exists
#   if (!file.exists(csv_file)) {
#     stop('CSV file not found in persona folder: ', csv_file)
#   }
#   
#   # Load the CSV table
#   table <- read.csv(csv_file)
#   
#   # Ensure the relevant columns are numeric
#   if (!is.numeric(table$Raster_Val)) {
#     table$Raster_Val <- as.numeric(table$Raster_Val)
#   }
#   if (!is.numeric(table[[persona_id]])) {
#     table[[persona_id]] <- as.numeric(table[[persona_id]])
#   }
#   
#   # Loop through each raster file
#   for (raster_file in names(cropped_rasters)) {
#     # Get the cropped raster object
#     r <- cropped_rasters[[raster_file]]
#     
#     # Extract the base filename from the raster file (remove .tif and suffix after '_')
#     base_name <- gsub('(_\\\\\\\\\\\\\\\\d+)?\\\\\\\\\\\\\\\\.tif$', '', raster_file)
#     
#     # Filter the CSV table to get relevant rows for the current raster
#     raster_table <- table[grepl(paste0('^', base_name, '_?\\\\\\\\\\\\\\\\d*$'), table$Name), ]
#     
#     # Check if there are matching rows
#     if (nrow(raster_table) == 0) {
#       cat('No matching reclassification data found in CSV for raster', raster_file, '. Skipping...\\\\\\\\n')
#       next
#     }
#     
#     # Reclassify raster values based on the filtered CSV table
#     r[] <- raster_table[[persona_id]][match(getValues(r), raster_table$Raster_Val)]
#     
#     # Set NA values to 0 (or some other value if needed)
#     r[is.na(r)] <- 0
#     
#     # Add the modified raster object to the list
#     modified_rasters[[raster_file]] <- r
#   }
#   
#   # Return the modified rasters
#   return(modified_rasters)
# }
