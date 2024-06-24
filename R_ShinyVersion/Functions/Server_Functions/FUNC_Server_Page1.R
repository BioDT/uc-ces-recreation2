server_page1 <- function(input, output, session, shapefile_name_global) {
  library(sf)
  
  # define the directory to contain raw shapefiles
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
    
    # Update the reactiveValues object to create global variable
    shapefile_name_global$input_text <- shapefile_name
    
    # unzip folders containing shapefiles
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
    
    file_extension <- function(file) {
      tools::file_ext(file)
    }
    
    for (file in shapefile_files) {
      file.rename(file, file.path(unzip_dir, paste0(shapefile_name, ".", file_extension(file))))
    }
    
    renamed_shapefile_path <- file.path(unzip_dir, paste0(shapefile_name, ".shp"))
    shp <- try(st_read(renamed_shapefile_path), silent = TRUE)
    
    if (inherits(shp, "try-error")) {
      output$message <- renderText("Error reading shapefile.")
      return()
    }
    
    # Drop Z dimension if present
    shp <- st_zm(shp, drop = TRUE, what = "ZM")
    shp_crs <- st_crs(shp)
    print(paste("CRS of the shapefile:", shp_crs))
    
    # Check if CRS is null or if it is a missing value (NA)
    if (is.null(shp_crs) || is.na(shp_crs$epsg) || shp_crs$epsg != 4326) {
      print("Attempting to transform CRS to WGS84.")
      shp <- try(st_transform(shp, crs = 4326), silent = TRUE)
      if (inherits(shp, "try-error")) {
        output$message <- renderText("Error transforming CRS to WGS84.")
        return()
      }
    }
    
    # print output map on upload
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        setView(lng = -4.2026, lat = 57.1497, zoom = 6) %>%
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
    shp_crs <- st_crs(shp)
    print(paste("CRS of the existing shapefile:", shp_crs))
    
    # Check if CRS is null or if it is a missing value (NA)
    if (is.null(shp_crs) || is.na(shp_crs$epsg) || shp_crs$epsg != 4326) {
      print("Attempting to transform CRS to WGS84.")
      shp <- try(st_transform(shp, crs = 4326), silent = TRUE)
      if (inherits(shp, "try-error")) {
        output$message <- renderText("Error transforming CRS to WGS84.")
        return()
      }
    }
    
    shapefile_path <- sub("\\.shp$", "", shapefile_path)
    shapefile_name_global$input_text <- basename(shapefile_path)
    print(paste("Incoming global name: ", shapefile_name_global$input_text))
    
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        setView(lng = -4.2026, lat = 57.1497, zoom = 6) %>%
        addPolygons(data = shp)
    })
    
    output$message <- renderText(paste("Shapefile", basename(shapefile_path), "loaded and displayed."))
  })
  
  observeEvent(input$file_option, {
    if (input$file_option == "upload") {
      shinyjs::enable("shapefile")
      shinyjs::enable("shapefile_name")
      shinyjs::enable("upload")
      shinyjs::disable("existing_shapefile")
      shinyjs::disable("load_existing")
    } else {
      shinyjs::disable("shapefile")
      shinyjs::disable("shapefile_name")
      shinyjs::disable("upload")
      shinyjs::enable("existing_shapefile")
      shinyjs::enable("load_existing")
    }
  })
  
  observeEvent(input$shapefile, {
    reset("message")
  })
}