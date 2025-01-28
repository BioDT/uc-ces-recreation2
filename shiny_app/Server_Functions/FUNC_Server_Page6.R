# Page 6 is for running the model

# Define server for Page 6
server_page6 <- function(
    input, output, session, shapefile_name_global, persona_id_global, home_folder,
    input_folder, output_folder, persona_dir, upload_dir, boundary_dir, raster_folder,
    temp_folder
) {

    # reactive value for popluating 
    rv_local <- reactiveValues()
    rv_local$output_file <- NULL
    rv_local$raster_data <- NULL
    rv_local$area <- NULL

    area_too_big <- 1000  #km2



    # checking and setting Persona ID
    observe(
        {
            #print(paste('Incoming global name: ', shapefile_name_global$input_text)) # debugging script

            shapefile_name <- shapefile_name_global$input_text
            persona_id <- persona_id_global$input_text

            shapefile_name <- sub("\\.shp$", "", shapefile_name)  # added to strip extension

            if (!is.null(shapefile_name) &&
                !is.null(persona_id)) {
                output$summary <- renderText(
                  {
                    paste("Shapefile Name:", shapefile_name, "\nPersona ID:", persona_id)
                  }
              )
            } else {
                output$summary <- renderText("Shapefile name or Persona ID is missing.")
            }
        }
    )

    # Run the model
    observeEvent(
        input$run_model, label = "Running the model", {

            #showNotification('Running the model...', type = 'message')
            waiter::waiter_show(
                html = tagList(waiter::spin_fading_circles(), "0/11 preparing files to run the model.....")
            )
            #housekeeping
            # Define the paths and variables required by the script
            shapefile_name <- shapefile_name_global$input_text
            Raw_Shapefile <- paste0(upload_dir, shapefile_name)
            persona_id <- persona_id_global$input_text

            Boundary_name <- shapefile_name
            Score_column <- persona_id
            #print(paste('Boundary_name: ', Boundary_name))  # debugging script
            #print(paste('Score column: ', Score_column))  # debugging script
            #print(paste('Raw_Shapefile Path: ', Raw_Shapefile))  # debugging script
            resolution <- 20
            max_distance <- 1500

            # Construct the path to the CSV file (assuming a fixed CSV filename)
            csv_file <- paste0(persona_dir, "/", persona_id, ".csv")

            # Check if the CSV persona file exists
            persona_table <- NULL
            if (!file.exists(csv_file)) {
                stop("CSV file not found in persona folder: ", csv_file)
            } else {
                # Load the CSV table
                persona_table <- read.csv(csv_file)
            }



            #### start ####
            start_time_g <- Sys.time()

            waiter::waiter_hide()
            waiter::waiter_show(html = tagList(waiter::spin_fading_circles(), "1/11 running the model"))

            if (is.null(shapefile_name) ||
                is.null(persona_id)) {
                showNotification("Shapefile name or Persona ID is missing.", type = "error")
                return()
            }

            ###################################################
            # Process the area of interest: cropping ##########
            ###################################################
            start_time_0 <- Sys.time()

            waiter::waiter_hide()
            waiter::waiter_show(
                html = tagList(waiter::spin_fading_circles(), "2/11 defining the area of interest")
            )

            #define the area of interest
            area_of_interest <- process_area_of_interest(Raw_Shapefile, Boundary_name, boundary_dir, resolution, max_distance)
            Raster_Empty <- area_of_interest$Raster_Empty
            mask_boundary <- area_of_interest$mask_boundary

            #print how big it is
            rv_local$area <- round(
                as.numeric(sf::st_area(mask_boundary)/1e+06),
                2
            )
            print(paste0("AREA shape km2:", rv_local$area))

            #crop to shape
            SLSRA_raster <- terra::rast(file.path(raster_folder, "SLSRA.tif"))
            FIPS_N_raster <- terra::rast(file.path(raster_folder, "FIPS_N.tif"))
            FIPS_N_Slope_raster <- terra::rast(file.path(raster_folder, "FIPS_N_Slope.tif"))
            FIPS_I_raster <- terra::rast(file.path(raster_folder, "FIPS_I.tif"))
            Water_raster <- terra::rast(file.path(raster_folder, "Water.tif"))

            # crop and mask to shape extent
            cropped_SLSRA <- terra::crop(SLSRA_raster, Raster_Empty)
            cropped_FIPS_N <- terra::crop(FIPS_N_raster, Raster_Empty)
            cropped_FIPS_N_Slope <- terra::crop(FIPS_N_Slope_raster, Raster_Empty)
            cropped_FIPS_I <- terra::crop(FIPS_I_raster, Raster_Empty)
            cropped_Water <- terra::crop(Water_raster, Raster_Empty)

            ### print how long it took
            #showNotification('Process area of interest COMPLETE.', type = 'message', duration = 20) # Notify user that component has run
            end_time_0 <- Sys.time()
            print(
                paste(
                  "Process the area of interest took", calculate_time_diff(start_time_0, end_time_0)
              )
            )


            #################################################################################
            # Process the persona specific scores: Reclassify the Rasters ###################
            #################################################################################
            waiter::waiter_hide()
            waiter::waiter_show(
                html = tagList(waiter::spin_fading_circles(), "3/11 processing the persona specific scores")
            )

            start_time_recl <- Sys.time()

            #component 1
            modified_SLSRA <- reclassify_rasters(cropped_SLSRA, raster_folder, persona_table, persona_id)
            #modified_SLSRA_par  <- reclassify_rasters_par(cropped_SLSRA, raster_folder, persona_table, persona_id,num_cores)

            #component 2
            modified_FIPS_N <- reclassify_rasters(cropped_FIPS_N, raster_folder, persona_table, persona_id)

            # slope is handled differently as it needs to transform all raster values by group value (e.g. easy, gentle etc...)
            table <- read.csv(paste0(persona_dir, "/", persona_id, ".csv"))  # import whole Persona table
            slope_table <- table[grepl("FIPS_N_Slope", table$Name),
                ]  # extract slope variables
            slope_df <- data.frame(
                group_val_min = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
                group_val_max = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
                score = slope_table[[persona_id]]
            )  # create a new df with slope and scores
            reclass_m <- data.matrix(slope_df)  # convert to matrix
            modified_FIPS_N <- c(modified_FIPS_N, terra::classify(cropped_FIPS_N_Slope, rcl = reclass_m))

            #component 3
            modified_FIPS_I <- reclassify_rasters(cropped_FIPS_I, raster_folder, persona_table, persona_id)

            #component 4
            modified_Water <- reclassify_rasters(cropped_Water, raster_folder, persona_table, persona_id)

            end_time_recl <- Sys.time()
            print(
                paste(
                  "process the persona scores took: ", calculate_time_diff(start_time_recl, end_time_recl)
              )
            )



            #######################################################################
            # calculate proximity distance for certain components
            ########################################################################
            waiter::waiter_hide()
            waiter::waiter_show(html = tagList(waiter::spin_fading_circles(), "4/11 processing proximity"))

            start_time_dist <- Sys.time()
            #component 3
            modified_FIPS_I <- terra::sapp(x = modified_FIPS_I, fun = process_raster_proximity, max_distance)
            modified_FIPS_I <- terra::sapp(x = modified_FIPS_I, fun = calculate_euclidean_distance)  # calculate euclidean distance values

            #component 4
            modified_Water <- terra::sapp(x = modified_Water, fun = process_raster_proximity, max_distance)
            modified_Water <- terra::sapp(x = modified_Water, fun = calculate_euclidean_distance)  # calculate euclidean distance values

            end_time_dist <- Sys.time()
            print(
                paste(
                  "process the proximity took: ", calculate_time_diff(start_time_dist, end_time_dist)
              )
            )

            #################################################################################
            # add all layers and normalize to a 0-1 value ###################################
            #################################################################################
            waiter::waiter_hide()
            waiter::waiter_show(html = tagList(waiter::spin_fading_circles(), "5/11 normalising scores"))

            start_time_norm <- Sys.time()
            #component 1
            SLSRA_Norm <- normalise_rasters(modified_SLSRA, terra::rast(Raster_Empty))

            #component 2
            FIPS_N_Norm <- normalise_rasters(modified_FIPS_N, terra::rast(Raster_Empty))

            #component 3
            FIPS_I_Norm <- normalise_rasters(modified_FIPS_I, terra::rast(Raster_Empty))

            #component 4
            Water_Norm <- normalise_rasters(modified_Water, terra::rast(Raster_Empty))

            end_time_norm <- Sys.time()
            print(
                paste(
                  "normalising the rasters took: ", calculate_time_diff(start_time_norm, end_time_norm)
              )
            )


            #################################################################################
            # mask to only precise shape needed #############################################
            #################################################################################
            waiter::waiter_hide()
            waiter::waiter_show(
                html = tagList(waiter::spin_fading_circles(), "6/11 masking to specific shape")
            )

            start_time_mask <- Sys.time()
            #component 1
            SLSRA_Norm <- terra::mask(SLSRA_Norm, mask_boundary)
            #component 2
            FIPS_N_Norm <- terra::mask(FIPS_N_Norm, mask_boundary)
            #component 3
            FIPS_I_Norm <- terra::mask(FIPS_I_Norm, mask_boundary)
            #component 4
            Water_Norm <- terra::mask(Water_Norm, mask_boundary)

            end_time_mask <- Sys.time()
            print(
                paste(
                  "masking the rasters took: ", calculate_time_diff(start_time_mask, end_time_mask)
              )
            )


            waiter::waiter_hide()
            waiter::waiter_show(
                html = tagList(waiter::spin_fading_circles(), "7/11 masking to specific shape")
            )


            #################################################################################
            # remove from memory ############################################################
            #################################################################################
            waiter::waiter_hide()
            waiter::waiter_show(
                html = tagList(waiter::spin_fading_circles(), "8/11 removing excess data from memory")
            )
            start_time_remove <- Sys.time()

            #component 1
            rm(cropped_SLSRA, modified_SLSRA)
            #component 2
            rm(reclass_m, cropped_FIPS_N, cropped_FIPS_N_Slope, modified_FIPS_N)
            #component 3
            rm(cropped_FIPS_I, modified_FIPS_I)
            # componenet 4
            rm(cropped_Water, modified_Water)

            end_time_remove <- Sys.time()
            print(
                paste(
                  "removing excess data from memory took: ", calculate_time_diff(start_time_remove, end_time_remove)
              )
            )

            ###############################################
            # Large case: save the rasters if too large ###
            ###############################################
            if (rv_local$area >= area_too_big) {
                waiter::waiter_hide()
                waiter::waiter_show(
                  html = tagList(
                    waiter::spin_fading_circles(), paste0(
                      "9/11 the area of this case is ", round(rv_local$area, 2),
                      " which is larger than ", area_too_big, " so, one extra step is needed"
                  )
                )
              )
                print(
                  paste0(
                    "the area of this case is ", round(rv_local$area, 2),
                    " which is larger than ", area_too_big, " so, one extra step is needed"
                )
              )
                start_time_extra <- Sys.time()

                #write component to avoid memory issue
                Norm_rasters <- c(SLSRA_Norm, FIPS_N_Norm, FIPS_I_Norm, Water_Norm)
                names(Norm_rasters) <- c("SLSRA_Norm", "FIPS_N_Norm", "FIPS_I_Norm", "Water_Norm")

                terra::writeRaster(
                  Norm_rasters, paste0(temp_folder, "Norm_rasters.tif"),
                  overwrite = TRUE
              )
                #remove objects from memory
                rm(Norm_rasters, SLSRA_Norm, FIPS_N_Norm, FIPS_I_Norm, Water_Norm)

                end_time_extra <- Sys.time()
                print(
                  paste(
                    "solving memory issue took: ", calculate_time_diff(start_time_extra, end_time_extra)
                )
              )
            }

            ###############################################
            # Compute and normalize final RP Model ########
            ###############################################
            waiter::waiter_hide()
            waiter::waiter_show(
                html = tagList(waiter::spin_fading_circles(), "10/11 normalize all components")
            )
            # find all normalised component rasters belonging to persona
            start_time_5 <- Sys.time()

            #read from folder if large and sum component rasters
            if (rv_local$area >= area_too_big) {
                Norm_rasters <- terra::rast(paste0(temp_folder, "Norm_rasters.tif"))
                sum_raster <- terra::app(Norm_rasters, fun = sum)
                #delete it from memeory
                file.remove(paste0(temp_folder, "Norm_rasters.tif"))
                #or read from local memory and sum component rasters
            } else {
                sum_raster <- Water_Norm + FIPS_I_Norm + FIPS_N_Norm + SLSRA_Norm
            }

            #normalize them
            BioDT_RP_Norm <- (sum_raster - min(sum_raster[], na.rm = TRUE))/(max(sum_raster[], na.rm = TRUE) -
                min(sum_raster[], na.rm = TRUE))
            rm(sum_raster)
            #mask them
            BioDT_RP_Norm <- terra::mask(BioDT_RP_Norm, mask_boundary)

            #save the output
            output_file <- file.path(
                output_folder, paste0("recreation_potential_", Boundary_name, "_", Score_column, ".tif")
            )
            terra::writeRaster(BioDT_RP_Norm, output_file, overwrite = TRUE)

            end_time_5 <- Sys.time()
            print(
                paste(
                  "Compute and normalise final RP Model", calculate_time_diff(start_time_5, end_time_5)
              )
            )

            ###############################################
            # Saving the output ###########################
            ###############################################
            waiter::waiter_hide()
            waiter::waiter_show(html = tagList(waiter::spin_fading_circles(), "11/11 saving the output"))
            start_time_6 <- Sys.time()

            #Store the output file path in the reactive value
            rv_local$output_file <- output_file
            rv_local$raster_data <- BioDT_RP_Norm

            end_time_6 <- Sys.time()
            print(paste("Saving output took:", calculate_time_diff(start_time_6, end_time_6)))

            ###############################################
            # Fisnish #####################################
            ###############################################
            end_time_g <- Sys.time()
            print(
                paste("finished, total runtime was ", calculate_time_diff(start_time_g, end_time_g))
            )
            waiter::waiter_hide()

        }
    )

    # Define color scheme for 7 quantile categories
    category_colors <- c("#3b1f47", "#a892b2", "#c2b5a6", "#f7ef99", "#cbcb6d", "#8a9f49", "#325e20")

    # Render Leaflet Map with Raster Overlay
    output$map_output <- renderLeaflet(
        {
            req(isTruthy(rv_local$output_file))

            # Get the CRS of the raster
            raster_data <- rv_local$raster_data
            raster_crs <- crs(raster_data)  # Extract the CRS

            # Ensure CRS of raster data matches Leaflet's EPSG:3857
            if (!is.null(raster_crs) &&
                !is.na(raster_crs)) {
                raster_data <- terra::project(raster_data, crs("EPSG:3857"))
            }


            if (rv_local$area >= area_too_big) {
                raster_data <- terra::aggregate(raster_data, fact = 2, fun = mean)
                raster_data <- terra::app(raster_data, fun = function(x) round(x, 2))
            }


            # # Extract raster values and remove NAs
            # raster_vals <- terra::values(raster_data)
            # raster_vals <- raster_vals[!is.na(raster_vals)]

            # Calculate quantiles for 7 categories
            quantiles <- quantile(
                terra::values(raster_data),
                probs = seq(0, 1, length.out = 8),
                na.rm = TRUE
            )
            # Create a color palette based on quantiles
            pal <- colorBin(palette = category_colors, bins = quantiles, na.color = "transparent")

            # Create base leaflet map, default OpenStreetMap tiles
            leaflet() %>%
                addTiles(group = "OpenStreetMap") %>%
                addTiles(
                  urlTemplate = "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                  group = "Esri World Imagery", attribution = "Tiles © Esri"
              ) %>%
                #addTiles() %>%
            addRasterImage(
                raster_data, colors = pal, opacity = input$transparency, project = TRUE,
                group = "Raster Overlay"
            ) %>%
                addLayersControl(
                  baseGroups = c("OpenStreetMap", "Esri World Imagery"),
                  overlayGroups = c("Raster Overlay"),
                  options = layersControlOptions(collapsed = FALSE)
              ) %>%
                leaflet.extras::addDrawToolbar(
                  targetGroup = "drawnShapes", polygonOptions = leaflet.extras::drawPolygonOptions(shapeOptions = leaflet.extras::drawShapeOptions(color = "blue")),
                  rectangleOptions = leaflet.extras::drawRectangleOptions(shapeOptions = leaflet.extras::drawShapeOptions(color = "red")),
                  circleOptions = leaflet.extras::drawCircleOptions(shapeOptions = leaflet.extras::drawShapeOptions(color = "green")),
                  editOptions = leaflet.extras::editToolbarOptions(edit = TRUE, remove = TRUE)
              ) %>%
                # Add measurement tool for distances and areas
            addMeasure(
                primaryLengthUnit = "kilometers", primaryAreaUnit = "hectares", activeColor = "#3D535D",
                completedColor = "#7D4479"
            ) %>%
                # Add a legend for the raster categories
            addLegend(
                position = "bottomright", pal = pal, values = terra::values(raster_data),
                title = "Quantile Categories", labFormat = labelFormat(digits = 2),
                opacity = 1
            )
        }
    )

    # calculate mean score values for drawn areas on map
    observeEvent(
        input$map_output_draw_new_feature, {
            feature <- input$map_output_draw_new_feature  # Get the drawn feature

            if (!is.null(feature)) {
                shape_type <- feature$geometry$type
                coords <- feature$geometry$coordinates

                # If the shape is a Polygon, extract raster values within the polygon
                if (shape_type == "Polygon") {
                  # Convert the coordinates to a matrix
                  polygon_coords <- do.call(rbind, lapply(coords[[1]], function(coord) c(coord[[1]], coord[[2]])))

                  # Create a simple features object
                  polygon_sf <- st_polygon(list(polygon_coords))
                  polygon_sf <- st_sfc(polygon_sf, crs = 4326)  # Assuming EPSG:4326 for original coordinates

                  # Transform the CRS of the polygon to match the raster's CRS
                  projected_polygon <- st_transform(polygon_sf, crs = st_crs(rv_local$raster_data))

                  # Extract raster values within the polygon
                  projected_polygon_spatvector <- terra::vect(projected_polygon)
                  raster_values <- terra::extract(rv_local$raster_data, projected_polygon_spatvector)

                  # Calculate mean value, ensure values are numeric
                  if (is.null(raster_values) ||
                    length(raster_values) ==
                      0 || all(is.na(raster_values))) {
                    mean_value <- NA
                  } else {
                    mean_value <- mean(
                      unlist(raster_values),
                      na.rm = TRUE
                  )
                  }

                  # Show result to the user
                  if (is.na(mean_value)) {
                    showNotification("No raster values found in the drawn polygon.", type = "warning")
                  } else {
                    showNotification(
                      paste("Mean raster value within polygon:", mean_value),
                      type = "message"
                  )
                  }
                }
            }
        }
    )

    # Handle editing of existing shapes
    observeEvent(
        input$map_draw_edited_features, {
            edited_features <- input$map_draw_edited_features  # Get edited features
            # Example: Display information about the edited shapes
            output$drawn_info <- renderPrint(
                {
                  paste("Edited shapes:", toString(edited_features))
                }
            )
        }
    )


    #Observe clicks on the map to extract raster values
    observeEvent(
        input$map_output_click, {

            click <- input$map_output_click

            if (!is.null(click)) {
                # Extract the clicked longitude and latitude
                clicked_coords <- c(click$lng, click$lat)

                # Create a SpatialPoints object and ensure it matches the raster CRS
                clicked_sp <- sp::SpatialPoints(
                  matrix(clicked_coords, ncol = 2),
                  proj4string = sp::CRS("+proj=longlat +datum=WGS84")
              )
                raster_crs <- terra::crs(rv_local$raster_data)

                # Transform the clicked points to the raster's CRS if necessary
                if (!raster::compareCRS(raster_crs, sp::CRS("+proj=longlat +datum=WGS84"))) {
                  clicked_sp <- sp::spTransform(clicked_sp, raster_crs)
                }

                # Extract the raster value at the clicked location
                clicked_sp_vect <- terra::vect(clicked_sp)
                raster_value <- terra::extract(rv_local$raster_data, clicked_sp_vect)

                # Show the clicked coordinate and raster value in a notification
                showNotification(
                  paste(
                    "Clicked at Longitude:", click$lng, "Latitude:", click$lat, "Raster Value:",
                    raster_value$sum, collapse =
                ),
                  type = "message"
              )
            }
        }
    )


    #Export the raster data as a .tif file
    output$export_tif <- downloadHandler(
        filename = function() {
            paste0(
                "recreation_potential_", shapefile_name_global$input_text, "_", persona_id_global$input_text,
                ".tif"
            )
        }, content = function(file) {
            file.copy(rv_local$output_file, file)
        }
    )



}
