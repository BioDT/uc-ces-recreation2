# Define server logic for Page 1
server_page1 <- function(input, output, session, shapefile_name_global) {
  upload_dir <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/Raw_Shapefile"
  
  # Function to list all shapefiles recursively
  list_shapefiles <- function(dir) {
    shapefile_paths <- list.files(dir, pattern = "\\.shp$", full.names = TRUE, recursive = TRUE)
    if (length(shapefile_paths) == 0) {
      return(NULL)
    }
    shapefile_names <- basename(shapefile_paths)
    shapefile_names <- tools::file_path_sans_ext(shapefile_names) 
    names(shapefile_paths) <- shapefile_names
    shapefile_paths
  }
  
  # Populate the dropdown with existing shapefiles when app loads
  observe({
    shapefiles <- list_shapefiles(upload_dir)
    if (!is.null(shapefiles)) {
      updateSelectInput(session, "existing_shapefile", choices = shapefiles)
    }
  })
  
  observeEvent(input$upload, {
    req(input$shapefile)
    req(input$shapefile_name)
    
    # Create a local variable
    shapefile_name <- input$shapefile_name
    
    # Update the reactiveValues object
    shapefile_name_global$input_text <- shapefile_name
    
    unzip_dir <- file.path(upload_dir, shapefile_name)
    
    if (!dir.exists(upload_dir)) {
      dir.create(upload_dir, recursive = TRUE)
    }
    
    temp_zip <- input$shapefile$datapath
    unzip(temp_zip, exdir = unzip_dir)
    
    shapefile_files <- list.files(unzip_dir, full.names = TRUE)
    shapefile_path <- list.files(unzip_dir, pattern = "\\.shp$", full.names = TRUE)
    
    if (length(shapefile_path) == 0) {
      output$message <- renderText("No shapefile found in the uploaded zip.")
      return()
    }
    
    # Rename shapefile files with the given name
    file_extension <- function(file) {
      tools::file_ext(file)
    }
    
    for (file in shapefile_files) {
      file.rename(file, file.path(unzip_dir, paste0(shapefile_name, ".", file_extension(file))))
    }
    
    # Read the renamed shapefile
    renamed_shapefile_path <- file.path(unzip_dir, paste0(shapefile_name, ".shp"))
    shp <- try(st_read(renamed_shapefile_path), silent = TRUE)
    
    if (inherits(shp, "try-error")) {
      output$message <- renderText("Error reading shapefile.")
      return()
    }
    
    # Drop Z dimension if present
    shp <- st_zm(shp, drop = TRUE, what = "ZM")
    
    # Transform CRS to WGS84 if necessary
    shp_crs <- st_crs(shp)
    if (is.null(shp_crs) || shp_crs$epsg != 4326) {
      shp <- try(st_transform(shp, crs = 4326), silent = TRUE)
      if (inherits(shp, "try-error")) {
        output$message <- renderText("Error transforming CRS to WGS84.")
        return()
      }
    }
    
    # Clear previous map
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        setView(lng = -4.2026, lat = 57.1497, zoom = 6) %>%  # Coordinates for Scotland
        addPolygons(data = shp)
    })
    
    output$message <- renderText(paste("Shapefile", shapefile_name, "uploaded and displayed."))
    
    # Update the dropdown list
    shapefiles <- list_shapefiles(upload_dir)
    if (!is.null(shapefiles)) {
      updateSelectInput(session, "existing_shapefile", choices = shapefiles)
    }
  })
  
  observeEvent(input$load_existing, {
    req(input$existing_shapefile)
    
    shapefile_path <- input$existing_shapefile
    shp <- try(st_read(shapefile_path), silent = TRUE)
    
    if (inherits(shp, "try-error")) {
      output$message <- renderText("Error reading shapefile.")
      return()
    }
    
    # Drop Z dimension if present
    shp <- st_zm(shp, drop = TRUE, what = "ZM")
    
    # Transform CRS to WGS84 if necessary
    shp_crs <- st_crs(shp)
    if (is.null(shp_crs) || shp_crs$epsg != 4326) {
      shp <- try(st_transform(shp, crs = 4326), silent = TRUE)
      if (inherits(shp, "try-error")) {
        output$message <- renderText("Error transforming CRS to WGS84.")
        return()
      }
    }
    
    # Update the reactiveValues object with the selected shapefile name
    shapefile_path <- sub("\\.shp$", "", shapefile_path)# added to strip extension
    print(paste("Incoming global name (page1): ", shapefile_path))
    shapefile_name_global$input_text <- basename(shapefile_path) # Update this line
    
    
    # Clear previous map
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        setView(lng = -4.2026, lat = 57.1497, zoom = 6) %>%  # Coordinates for Scotland
        addPolygons(data = shp)
    })
    
    output$message <- renderText(paste("Shapefile", basename(shapefile_path), "loaded and displayed."))
  })
  
  observeEvent(input$shapefile, {
    reset("message")
  })
}
