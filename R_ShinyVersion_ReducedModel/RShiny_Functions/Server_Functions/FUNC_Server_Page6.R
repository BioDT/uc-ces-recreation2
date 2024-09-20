# Page 6 is for running the model

# Define server for Page 6
server_page6 <- function(input, output, session, shapefile_name_global, persona_id_global, home_folder) {
  
  # reactive value for popluating 
  rv <- reactiveValues(output_file = NULL)
  
  # checking and setting Persona ID
  observe({
    print(paste("Incoming global name: ", shapefile_name_global$input_text)) # debugging script
    
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
  
  # Run the model
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
    print(paste("Boundary_name: ", Boundary_name))  # debugging script
    print(paste("Score column: ", Score_column))  # debugging script
    
    input_folder <- paste0(home_folder, "input")
    output_folder <- paste0(home_folder, "output")
    persona_folder <- paste0(home_folder, "output/Persona_Scores") # added a persona folder
    Raw_Shapefile <- file.path(input_folder, "Raw_Shapefile", shapefile_name)
    print(paste("Raw_Shapefile Path: ", Raw_Shapefile))  # debugging script
    resolution <- 20
    max_distance <- 1500
    
    # Load libraries - not sure whether this is needed if loaded in main RShiny script
    library(raster)
    library(tools)
    library(sf)
    library(dplyr)
    library(ggplot2)
    library(scales)
    library(RColorBrewer)
    library(leaflet)
    
    # Set working directory and source functions
    #setwd("/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel")
    source(paste0(home_folder, "FUNC_Raster_Reclassifier_single_csv.R")) #FUNC_Raster_Reclassifier_single_csv.R
    source(paste0(home_folder, "FUNC_Process_Raster_Proximity2.R"))
    source(paste0(home_folder, "FUNC_Calculate_Euclidean_Distance.R"))
    source(paste0(home_folder, "FUNC_Normalise_Rasters.R"))
    source(paste0(home_folder, "FUNC_Crop_Rasters_by_mask.R"))
    source(paste0(home_folder, "FUNC_Skip_Prox_on_Rasters_Without_NA.R"))
    source(paste0(home_folder, "FUNC_Process_Area_of_Interest.R"))
    
    # Process the area of interest
    area_of_interest <- process_area_of_interest(Raw_Shapefile, Boundary_name, input_folder, resolution, max_distance)
    Raster_Empty <- area_of_interest$Raster_Empty
    mask_boundary <- area_of_interest$mask_boundary
    print("Process area of interest COMPLETE") # debugging script
    showNotification("Process area of interest COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    # Component 1: SLSRA
    raster_folder <- file.path(input_folder, "SLSRA") # direct to correct raster folder
    cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty) # crop by mask
    modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, persona_folder, persona_id) # reclassify rasters (except slope) by parameterized values
    SLSRA_Norm <- normalise_rasters(modified_rasters, Raster_Empty) # normalise rasters
    SLSRA_Norm <- mask(SLSRA_Norm, mask_boundary) # crop by mask to clean up
    writeRaster(SLSRA_Norm, file.path(output_folder, paste0("Component_SLSRA_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE) # save component
    print("Process SLSRA COMPLETE") # debugging script
    showNotification("Process SLSRA component COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    # Component 2: FIPS_N
    raster_folder <- file.path(input_folder, "FIPS_N")
    slope_folder <- file.path(raster_folder, "slope")
    cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)
    modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, persona_folder, persona_id)
    # slope is handled differently as it needs to transform all raster values by group value (e.g. easy, gentle etc...)
    table <- read.csv(paste0(persona_folder, "/", persona_id, ".csv")) # import whole Persona table
    slope_table <- table[grepl("FIPS_N_Slope", table$Name), ] # extract slope variables
    slope_df <- data.frame(
      group_val_min = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
      group_val_max = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
      score = slope_table[[persona_id]]) # create a new df with slope and scores
    reclass_m <- data.matrix(slope_df) # convert to matrix
    Slope_Raster <- raster(file.path(slope_folder, "FIPS_N_Slope.tif")) # bring in slope raster
    Slope_Raster <- crop(Slope_Raster, Raster_Empty) # crop to region
    modified_rasters[["slope"]] <- reclassify(Slope_Raster, reclass_m) # reclassify all slope values in raster with scrores from grouped table
    # continue with rest of component processing
    FIPS_N_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
    FIPS_N_Norm <- mask(FIPS_N_Norm, mask_boundary)
    writeRaster(FIPS_N_Norm, file.path(output_folder, paste0("Component_FIPS_N_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)
    print("Process FIPS_N COMPLETE") # debugging script
    showNotification("Process FIPS_N component COMPLETE.", type = "message", duration = 20) # Notify user that component has run

    
    # Component 3: FIPS_I
    raster_folder <- file.path(input_folder, "FIPS_I")
    cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)
    modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, persona_folder, persona_id)
    modified_rasters <- lapply(modified_rasters, process_raster_proximity, max_distance) # calculate proximity values
    modified_rasters <- lapply(modified_rasters, calculate_euclidean_distance) # calculate euclidean distance values
    modified_rasters <- lapply(modified_rasters, normalise_rasters, Raster_Empty) # normalise individual rasters
    modified_rasters <- lapply(modified_rasters, mask, mask_boundary) # crop by mask
    FIPS_I_Norm <- normalise_rasters(modified_rasters, Raster_Empty) # normalise overall raster
    FIPS_I_Norm <- mask(FIPS_I_Norm, mask_boundary)
    writeRaster(FIPS_I_Norm, file.path(output_folder, paste0("Component_FIPS_I_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)
    print("Process FIPS_I COMPLETE") # debugging script
    showNotification("Process FIPS_I component COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    # Component 4: Water
    raster_folder <- file.path(input_folder, "Water")
    cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)
    modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, persona_folder, persona_id)
    modified_rasters <- lapply(modified_rasters, process_raster_proximity, max_distance)
    modified_rasters <- lapply(modified_rasters, calculate_euclidean_distance)
    modified_rasters <- lapply(modified_rasters, normalise_rasters, Raster_Empty)
    modified_rasters <- lapply(modified_rasters, mask, mask_boundary)
    Water_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
    Water_Norm <- mask(Water_Norm, mask_boundary)
    writeRaster(Water_Norm, file.path(output_folder, paste0("Component_Water_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)
    print("Process Water COMPLETE") # debugging script
    showNotification("Process Water component COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    # Compute and normalise final RP Model
    # find all normalised component rasters belonging to persona
    raster_files <- list.files(output_folder, pattern = paste0("^Component_.*_", Boundary_name, "_", Score_column, "\\.tif$"), full.names = TRUE)
    sum_raster <- Raster_Empty # create empty raster
    for (file in raster_files) {
      raster <- raster(file)
      sum_raster <- sum_raster + raster
    }
    BioDT_RP_Norm <- (sum_raster - min(sum_raster[], na.rm = TRUE)) / (max(sum_raster[], na.rm = TRUE) - min(sum_raster[], na.rm = TRUE)) # sum component rasters and normalise
    BioDT_RP_Norm <- mask(BioDT_RP_Norm, mask_boundary) # crop by boundary
    output_file <- file.path(output_folder, paste0("recreation_potential_", Boundary_name, "_", Score_column, ".tif"))
    writeRaster(BioDT_RP_Norm, output_file, format = "GTiff", overwrite = TRUE)
    print("Process Normalized RP COMPLETE") # debugging script
    showNotification("Process Normalized RP COMPLETE.", type = "message", duration = 20) # Notify user that component has run
    
    # Store the output file path in the reactive value
    rv$output_file <- output_file
    
    # clean up and remove component rasters from output folder
    # Get a list of all .tif files in the folder
    tif_files <- list.files(output_folder, pattern = "\\.tif$", full.names = TRUE)
    # Filter files that contain the word "COMPONENT"
    component_files <- tif_files[grepl("Component", tif_files)]
    # Remove the filtered files
    file.remove(component_files)
    
    
    # Store the output file path in the reactive value
    rv$raster_data <- BioDT_RP_Norm
    
    # Notify user that the model has finished running
    showNotification("Model has finished running.", type = "message")
    
  })
  
  
  # Define color scheme for 7 quantile categories
  category_colors <- c("#3b1f47", "#a892b2", "#c2b5a6", "#f7ef99", "#cbcb6d",  "#8a9f49", "#325e20")
  
  # Render Leaflet Map with Raster Overlay
  output$map_output <- renderLeaflet({
    req(rv$raster_data)
    
    # Extract raster values and remove NAs
    raster_vals <- values(rv$raster_data)
    raster_vals <- raster_vals[!is.na(raster_vals)]
    
    # Calculate quantiles for 7 categories
    quantiles <- quantile(raster_vals, probs = seq(0, 1, length.out = 8), na.rm = TRUE)
    
    # Create a color palette based on quantiles
    pal <- colorBin(palette = category_colors, bins = quantiles, na.color = "transparent")
    
    # Create base leaflet map
    leaflet() %>%
      addTiles() %>%
      addRasterImage(
        rv$raster_data,
        colors = pal,
        opacity = input$transparency
      ) %>%
      addLayersControl(
        overlayGroups = c("Raster Overlay"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
  
  # Observe transparency slider and update raster opacity
  observe({
    if (is.null(rv$raster_data)) {
      showNotification("Raster data is NULL. Cannot render map.", type = "error")
    } else {
      raster_vals <- values(rv$raster_data)
      raster_vals <- raster_vals[!is.na(raster_vals)]
      quantiles <- quantile(raster_vals, probs = seq(0, 1, length.out = 8), na.rm = TRUE)
      pal <- colorBin(palette = category_colors, bins = quantiles, na.color = "transparent")
      
      leafletProxy("map_output") %>%
        clearImages() %>%
        addRasterImage(
          rv$raster_data,
          colors = pal,
          opacity = input$transparency
        ) %>%
        addLayersControl(
          overlayGroups = c("Raster Overlay"),
          options = layersControlOptions(collapsed = FALSE)
        ) %>%
        addLegend(
          position = "bottomright",
          pal = pal,
          values = raster_vals,
          title = "Recreational Potential"
        )
    }
  })
  
  # Export the raster data as a .tif file
  output$export_tif <- downloadHandler(
    filename = function() {
      paste0("recreation_potential_", shapefile_name_global$input_text, "_", persona_id_global$input_text, ".tif")
    },
    content = function(file) {
      file.copy(rv$output_file, file)
    })
}