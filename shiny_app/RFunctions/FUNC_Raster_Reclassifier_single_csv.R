# step 3: make it faster
reclassify_rasters <- function(cropped_rasters, raster_folder, table, persona_id) {
    if (!is.null(table)) {
        # Ensure the relevant columns are numeric
        table$Raster_Val <- as.numeric(table$Raster_Val)
        table[[persona_id]] <- as.numeric(table[[persona_id]])

        # Loop through each layer of the spatrast
        for (alayer in seq_along(names(cropped_rasters))) {
            # get the name
            name_l <- names(cropped_rasters)[alayer]

            # Filter the table to get relevant rows for the current raster
            raster_table <- table[grepl(
                paste0("^", name_l, "_?\\d*$"),
                table$Name
            ), ]

            # Check if there are no matching rows, if so, skip
            if (nrow(raster_table) ==
                0) {
                cat(
                    "No matching reclassification data found in CSV for raster", raster_file,
                    ". Skipping...\n"
                )
                next
            }

            # make a lookup table that specifies what to substitute with what
            lookup <- setNames(raster_table[, persona_id], raster_table$Raster_Val)

            # replace values
            terra::values(cropped_rasters[[name_l]]) <- lookup[match(
                terra::values(cropped_rasters[[name_l]]),
                as.numeric(names(lookup))
            )]
            terra::values(cropped_rasters[[name_l]])[is.na(terra::values(cropped_rasters[[name_l]]))] <- 0 # Set NA values to 0
        }

        # Return the modified rasters
        return(cropped_rasters)
    }
}
