# Define server for Page 6
server_page6 <- function(input, output, session, shapefile_name_global, persona_id_global) {
  
  rv <- reactiveValues(output_file = NULL)
  
  observe({
    print(paste("Incoming global name: ", shapefile_name_global$input_text))
    
    shapefile_name <- shapefile_name_global$input_text
    persona_id <- persona_id_global$input_text
    
    shapefile_name <- sub("\\.shp$", "", shapefile_name) # added to strip extension
    
    if (!is.null(shapefile_name) && !is.null(persona_id)) {
      output$summary <- renderText({
        paste("Shapefile Name:", shapefile_name, "\nPersona ID:", persona_id)
      })
    } else {
      output$summary <- renderText("Shapefile name or Persona ID is missing.")
    }
  })
  
  observeEvent(input$run_model, {
    showNotification("Running the model...", type = "message")
    
    shapefile_name <- shapefile_name_global$input_text
    persona_id <- persona_id_global$input_text
    
    if (is.null(shapefile_name) || is.null(persona_id)) {
      showNotification("Shapefile name or Persona ID is missing.", type = "error")
      return()
    }
    
    # Define the paths and variables required by the script
    Boundary_name <- shapefile_name
    Score_column <- persona_id
    print(paste("Boundary_name: ", Boundary_name))  # debug output
    print(paste("Score column: ", Score_column))  # debug output
    
    input_folder <- "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input"
    output_folder <- "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/output"
    Raw_Shapefile <- file.path(input_folder, "Raw_Shapefile", shapefile_name)
    print(paste("Raw_Shapefile Path: ", Raw_Shapefile))  # debug output
    resolution <- 20
    max_distance <- 1500
    
    # Load libraries
    library(raster)
    library(tools)
    library(sf)
    library(dplyr)
    library(ggplot2)
    library(scales)
    
    # Set working directory and source functions
    setwd("/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel")
    source("FUNC_Raster_Reclassifier.R")
    source("FUNC_Process_Raster_Proximity2.R")
    source("FUNC_Calculate_Euclidean_Distance.R")
    source("FUNC_Normalise_Rasters.R")
    source("FUNC_Crop_Rasters_by_mask.R")
    source("FUNC_Skip_Prox_on_Rasters_Without_NA.R")
    source("FUNC_Process_Area_of_Interest.R")
    
    # Process the area of interest
    area_of_interest <- process_area_of_interest(Raw_Shapefile, Boundary_name, input_folder, resolution, max_distance)
    Raster_Empty <- area_of_interest$Raster_Empty
    mask_boundary <- area_of_interest$mask_boundary
    print("Process area of interest COMPLETE")
    showNotification("Process area of interest COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    # Assume Raster_Empty is the base raster for the area of interest, and it has a known resolution (e.g., 1 km)
    res(Raster_Empty) <- c(1000, 1000)  # Set the resolution to 1 km²
    
    # Define the extent of the area of interest
    ext <- extent(Raster_Empty)
    
    ##############################################
    # Component 1: SLSRA
    raster_folder <- file.path(input_folder, "SLSRA")
    cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)
    
    # Set up parallel processing for 1km² chunks
    n_cores <- detectCores() - 1
    cl <- makeCluster(n_cores)
    registerDoParallel(cl)
    
    # Calculate the number of rows and columns for tiling
    tile_size <- 1000
    n_rows <- ceiling((ext@ymax - ext@ymin) / tile_size)
    n_cols <- ceiling((ext@xmax - ext@xmin) / tile_size)
    
    # Initialize an empty raster to store the final result
    SLSRA_Norm <- Raster_Empty
    
    # Parallel processing of 1km² chunks
    results <- foreach(i = 1:n_rows, .combine = 'list', .packages = c('raster', 'sf', 'dplyr')) %:%
      foreach(j = 1:n_cols, .combine = 'list') %dopar% {
        # Define the extent for the current chunk
        xmin <- ext@xmin + (j-1) * tile_size
        xmax <- xmin + tile_size
        ymin <- ext@ymin + (i-1) * tile_size
        ymax <- ymin + tile_size
        chunk_extent <- extent(xmin, xmax, ymin, ymax)
        
        # Crop the raster to the current chunk
        chunk_raster <- crop(Raster_Empty, chunk_extent)
        
        # Process the chunk (reclassify, normalize, mask)
        reclassified_chunk <- reclassify_rasters(chunk_raster, raster_folder, Score_column)  
        normalized_chunk <- normalise_rasters(reclassified_chunk, Raster_Empty)
        masked_chunk <- mask(normalized_chunk, mask_boundary)
        
        # Return the processed chunk
        return(masked_chunk)
      }
    
    # Combine the processed chunks into the final raster
    SLSRA_Norm <- do.call(merge, results)
    
    # Write the final processed raster for the SLSRA component
    output_file <- file.path(output_folder, paste0("Component_SLSRA_", Boundary_name, "_", Score_column, ".tif"))
    writeRaster(SLSRA_Norm, output_file, format = "GTiff", overwrite = TRUE)
    
    # Stop the cluster after processing is complete
    stopCluster(cl)
    
    print("Process SLSRA COMPLETE")
    showNotification("Process SLSRA component COMPLETE.", type = "message", duration = 20)
    
    #################################
    # Component 2: FIPS_N
    raster_folder <- file.path(input_folder, "FIPS_N")
    slope_folder <- file.path(raster_folder, "slope")
    cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)
    modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, Score_column)
    slope_df <- data.frame(
      group_val_min = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
      group_val_max = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
      score = read.csv(file.path(slope_folder, "FIPS_N_Slope.csv"))[[Score_column]]
    )
    reclass_m <- data.matrix(slope_df)
    Slope_Raster <- raster(file.path(slope_folder, "FIPS_N_Slope.tif"))
    Slope_Raster <- crop(Slope_Raster, Raster_Empty)
    modified_rasters[["slope"]] <- reclassify(Slope_Raster, reclass_m)
    FIPS_N_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
    FIPS_N_Norm <- mask(FIPS_N_Norm, mask_boundary)
    writeRaster(FIPS_N_Norm, file.path(output_folder, paste0("Component_FIPS_N_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)
    print("Process FIPS_N COMPLETE")
    showNotification("Process FIPS_N component COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    # Component 3: FIPS_I
    raster_folder <- file.path(input_folder, "FIPS_I")
    cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)
    modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, Score_column)
    modified_rasters <- lapply(modified_rasters, process_raster_proximity, max_distance)
    modified_rasters <- lapply(modified_rasters, calculate_euclidean_distance)
    modified_rasters <- lapply(modified_rasters, normalise_rasters, Raster_Empty)
    modified_rasters <- lapply(modified_rasters, mask, mask_boundary)
    FIPS_I_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
    FIPS_I_Norm <- mask(FIPS_I_Norm, mask_boundary)
    writeRaster(FIPS_I_Norm, file.path(output_folder, paste0("Component_FIPS_I_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)
    print("Process FIPS_I COMPLETE")
    showNotification("Process FIPS_I component COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    # Component 4: Water
    raster_folder <- file.path(input_folder, "Water")
    cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)
    modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, Score_column)
    modified_rasters <- lapply(modified_rasters, process_raster_proximity, max_distance)
    modified_rasters <- lapply(modified_rasters, calculate_euclidean_distance)
    modified_rasters <- lapply(modified_rasters, normalise_rasters, Raster_Empty)
    modified_rasters <- lapply(modified_rasters, mask, mask_boundary)
    Water_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
    Water_Norm <- mask(Water_Norm, mask_boundary)
    writeRaster(Water_Norm, file.path(output_folder, paste0("Component_Water_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)
    print("Process Water COMPLETE")
    showNotification("Process Water component COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    
    # Compute and normalize final RP Model
    raster_files <- list.files(output_folder, pattern = paste0("^Component_.*_", shapefile_name, "_", persona_id, "\\.tif$"), full.names = TRUE)
    sum_raster <- Raster_Empty
    for (file in raster_files) {
      raster <- raster(file)
      sum_raster <- sum_raster + raster
    }
    BioDT_RP_Norm <- (sum_raster - min(sum_raster[], na.rm = TRUE)) / (max(sum_raster[], na.rm = TRUE) - min(sum_raster[], na.rm = TRUE))
    BioDT_RP_Norm <- mask(BioDT_RP_Norm, mask_boundary)
    output_file <- file.path(output_folder, paste0("recreation_potential_", shapefile_name, "_", persona_id, ".tif"))
    writeRaster(BioDT_RP_Norm, output_file, format = "GTiff", overwrite = TRUE)
    
    # Store output file and notify user
    rv$output_file <- output_file
    showNotification("Model has finished running.", type = "message")
    
    # Display the final raster output
    output$raster_output <- renderPlot({
      raster_data <- raster(output_file)
      plot(raster_data, main = paste("Recreation Potential for", shapefile_name))
    })
  })
  
  # Download the final output
  output$export_tif <- downloadHandler(
    filename = function() {
      paste0("recreation_potential_", shapefile_name_global$input_text, "_", persona_id_global$input_text, ".tif")
    },
    content = function(file) {
      file.copy(rv$output_file, file)
    }
  )
}