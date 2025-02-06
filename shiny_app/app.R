library(shiny)
library(leaflet)
library(leaflet.extras)

#devtools::load_all("../model")
devtools::install_github("BioDT/uc-ces-recreation2", subdir = "model", ref = "develop")

source("about.R")  # contains about_html
source("theme.R")  # contains custom_theme, custom_titlePanel


.credentials <- data.frame(
    user = Sys.getenv("APP_USERNAME"),
    password = Sys.getenv("APP_PASSWORD")
)

.raster_dir <- "data"
.persona_dir <- "personas"
.example_persona_csv <- file.path(.persona_dir, "examples.csv")
.config <- load_config()
.layer_info <- setNames(.config[["Description"]], .config[["Name"]])
.layer_names <- names(.layer_info)
.max_area <- 1e9  # about 1/4 of the Cairngorms area
.min_area <- 1e4
.data_extent <- terra::ext(-10000, 660000, 460000, 1220000)  # Scotland bbox

list_persona_files <- function() {
    return(list.files(path = .persona_dir, pattern = "\\.csv$", full.names = FALSE))
}

list_users <- function() lapply(list_persona_files(), tools::file_path_sans_ext)

list_personas_in_file <- function(file_name) {
    personas <- names(read.csv(file.path(.persona_dir, file_name), nrows = 1))
    return(personas[personas != "index"])
}

remove_non_alphanumeric <- function(string) {
    string <- gsub(" ", "_", string)  # Spaces to underscore
    string <- gsub("[^a-zA-Z0-9_]+", "", string)  # remove non alpha-numeric
    string <- gsub("^_+|_+$", "", string)  # remove leading or trailing underscores
    return(string)
}

create_sliders <- function(component) {
    layer_names_this_component <- .layer_names[startsWith(.layer_names, component)]
    sliders <- lapply(layer_names_this_component, function(layer_name) {
        sliderInput(
            layer_name,
            label = .layer_info[[layer_name]],
            min = 0,
            max = 10,
            value = 0,
            round = TRUE,
            ticks = FALSE
        )
    })

    # Divide sliders into two rows
    n <- length(sliders)
    sliders_left <- sliders[seq(1, n, by = 2)]
    sliders_right <- sliders[seq(2, n, by = 2)]

    fluidRow(
        column(width = 6, sliders_left),
        column(width = 6, sliders_right)
    )
}

palette <- colorNumeric(
    palette = "viridis",
    domain = c(0, 1),
    na.color = "transparent"
)

check_valid_bbox <- function(bbox) {
    if (is.null(bbox)) {
        message("No area has been selected. Please select an area.")
        return(FALSE)
    }
    area <- (terra::xmax(bbox) - terra::xmin(bbox)) * (terra::ymax(bbox) - terra::ymin(bbox))
    if (area > .max_area) {
        message(paste(
            "The area you have selected is too large to be computed at this time",
            "(", sprintf("%.1e", area), ">", .max_area, " m^2 ).",
            "Please draw a smaller area."
        ))
        return(FALSE)
    }
    if (area < .min_area) {
        message(paste(
            "The area you have selected is too small",
            "(", round(area), "<", .min_area, " m^2 ).",
            "Please draw a larger area."
        ))
        return(FALSE)
    }

    within_data_bounds <- (
        terra::xmin(bbox) >= terra::xmin(.data_extent) &&
        terra::xmax(bbox) <= terra::xmax(.data_extent) &&
        terra::ymin(bbox) >= terra::ymin(.data_extent) &&
        terra::ymax(bbox) <= terra::ymax(.data_extent)
    )
    if (!within_data_bounds) {
        message("The area you have selected exceeds the boundaries where we have data (i.e. Scotland)")
        return(FALSE)
    }
    return(TRUE)
}

check_valid_persona <- function(persona) {
    if (all(sapply(persona, function(score) score == 0))) {   
        message("All the persona scores are zero. At least one score must be non-zero.")
        message("Perhaps you have forgotten to load a persona?")
        return(FALSE)
    }
    return(TRUE)
}

ui <- fluidPage(
    theme = custom_theme,
    tags$head(
        tags$style(HTML("
            html, body {height: 100%;}
            #map {height: 80vh !important;}
        "))
    ),
    # Add title, contact address and privacy notice in combined title panel + header
    fluidRow(
        style = "background-color: #f8f9fa;",
        custom_titlePanel("Recreational Potential Model for Scotland")
    ),
    fluidRow(
        column(
            width = 5,
            tabsetPanel(
                tabPanel("About", about_html),
                tabPanel("SLSRA", create_sliders("SLSRA")),
                tabPanel("FIPS_N", create_sliders("FIPS_N")),
                tabPanel("FIPS_I", create_sliders("FIPS_I")),
                tabPanel("Water", create_sliders("Water"))
            )
        ),
        column(
            width = 7,
            fluidRow(
                column(
                    width = 8,
                    actionButton("loadButton", "Load Persona"),
                    actionButton("saveButton", "Save Persona"),
                    actionButton("updateButton", "Update Map"),
                    radioButtons(
                        "layerSelect",
                        "",
                        choices = list(
                            "SLSRA" = 1,
                            "FIPS_N" = 2,
                            "FIPS_I" = 3,
                            "Water" = 4,
                            "Recreational Potential" = 5
                        ),
                        selected = 5,
                        inline = TRUE
                    )
                ),
                column(
                    width = 4,
                    sliderInput(
                        "opacity",
                        "Layer Opacity",
                        min = 0,
                        max = 1,
                        value = 0.8,
                        step = 0.2,
                        ticks = FALSE
                    )
                )
            ),
            verbatimTextOutput("userInfo"),
            tags$head(
                tags$style(HTML("
                    .leaflet-draw-toolbar a {background-color: red !important;}
                "))
            ),
            leafletOutput("map")
        ),
        tags$div(
            style = "text-align: center; background-color: #f8f9fa; border: 1px solid #ccc; padding: 10px; border-radius: 5px;", #nolint
            "© UK Centre for Ecology & Hydrology, 2025",
        )
    )
)

# Add password authorisation
ui <- shinymanager::secure_app(ui)

server <- function(input, output, session) {
    # Check credentials
    res_auth <- shinymanager::secure_server(
        check_credentials = shinymanager::check_credentials(.credentials)
    )
    output$auth_output <- renderPrint({
        reactiveValuesToList(res_auth)
    })


    get_persona_from_sliders <- function() {
        persona <- sapply(
            .layer_names,
            function(layer_name) input[[layer_name]],
            USE.NAMES = TRUE
        )
        return(persona)
    }

    # Reactive variable to track the csv file that's been selected for loading
    reactiveLoadFile <- reactiveVal()

    # Reactive variable for caching computed raster
    reactiveLayers <- reactiveVal()

    # Reactive variable for coordinates of user-drawn bbox
    reactiveExtent <- reactiveVal()

    # ------------------------------------------------------ Loading

    # Open a dialogue box to load a new persona
    observeEvent(input$loadButton, {
        showModal(
            modalDialog(
                title = "Load Persona",
                selectInput(
                    "loadUserSelect",
                    "Select user",
                    choices = list_users(),
                    selected = "examples"
                ),
                selectInput(
                    "loadPersonaSelect",
                    "Select persona",
                    choices = NULL,
                    selected = NULL
                ),
                footer = tagList(
                    modalButton("Cancel"),
                    actionButton("confirmLoad", "Load")
                )
            )
        )
    })
    observeEvent(input$loadUserSelect, {
        req(input$loadUserSelect)
        reactiveLoadFile(paste0(input$loadUserSelect, ".csv"))
    })
    observeEvent(reactiveLoadFile(), {
        updateSelectInput(
            session,
            "loadPersonaSelect",
            choices = list_personas_in_file(reactiveLoadFile())
        )
    })
    observeEvent(input$confirmLoad, {
        loaded_persona <- model::load_persona(
            file.path(.persona_dir, reactiveLoadFile()),
            input$loadPersonaSelect
        )
        # Apply new persona to sliders
        lapply(names(loaded_persona), function(layer_name) {
            updateSliderInput(
                session,
                inputId = layer_name,
                value = loaded_persona[[layer_name]]
            )
        })

        output$userInfo <- renderPrint({
            paste("Loaded persona", input$loadPersonaSelect, "from file", reactiveLoadFile())
        })

        removeModal()
    })

    # ------------------------------------------------------ Saving
    observeEvent(input$saveButton, {
        showModal(
            modalDialog(
                title = "Save Persona",
                selectInput(
                    "saveUserSelect",
                    "Select existing user",
                    choices = c("", list_users())
                ),
                textInput("saveUserName", "Or enter a new user name"),
                textInput(
                    "savePersonaName",
                    "Enter a name for the persona",
                    value = NULL
                ),
                footer = tagList(
                    modalButton("Cancel"),
                    actionButton("confirmSave", "Save")
                )
            )
        )
    })
    observeEvent(input$confirmSave, {
        user_name <- if (input$saveUserName != "") input$saveUserName else input$saveUserSelect
        persona_name <- input$savePersonaName

        # Remove characters that may cause problems with i/o and dataframe filtering
        user_name <- remove_non_alphanumeric(user_name)
        persona_name <- remove_non_alphanumeric(persona_name)

        msg <- capture.output(
            model::save_persona(
                persona = get_persona_from_sliders(),
                csv_path = file.path(.persona_dir, paste0(user_name, ".csv")),
                name = persona_name
            ),
            type = "message"
        )

        output$userInfo <- renderPrint({
            cat(msg, sep = "\n")
        })

        removeModal()
    })


    # --------------------------------------------------------------- Map
    # Initialize Leaflet map
    output$map <- renderLeaflet({
        leaflet() |>
            setView(lng = -4.2026, lat = 56.4907, zoom = 7) |>
            addTiles() |>
            addLegend(
                title = "Values",
                position = "topright",
                values = c(0, 1),
                pal = palette
            ) |>
            addFullscreenControl() |>
            addDrawToolbar(
                targetGroup = "drawnItems",
                singleFeature = TRUE,
                rectangleOptions = drawRectangleOptions(
                    shapeOptions = drawShapeOptions(
                        color = "#FF0000",
                        weight = 2,
                        fillOpacity = 0
                    )
                ),
                polylineOptions = FALSE,
                polygonOptions = FALSE,
                circleOptions = FALSE,
                markerOptions = FALSE,
                circleMarkerOptions = FALSE
            )
    })

    # Grabs cached layers and updates map with current layer selection
    update_map <- function() {
        req(reactiveLayers())

        layers <- reactiveLayers()
        curr_layer <- layers[[as.numeric(input$layerSelect)]]

        leafletProxy("map") |>
            clearImages() |>
            addRasterImage(curr_layer, colors = palette, opacity = input$opacity)
    }

    # Draw rectangle
    # NOTE: input$map_draw_new_feature automatically created by leaflet.extras
    # when using addDrawToolbar()
    observeEvent(input$map_draw_new_feature, {
        bbox <- input$map_draw_new_feature

        stopifnot(bbox$geometry$type == "Polygon")

        # This is pretty hacky - must be a cleaner way...
        coords <- bbox$geometry$coordinates[[1]]
        lons <- unlist(sapply(coords, function(coord) coord[1]))
        lats <- unlist(sapply(coords, function(coord) coord[2]))
        xmin <- min(lons)
        xmax <- max(lons)
        ymin <- min(lats)
        ymax <- max(lats)

        # Fit the map to these bounds
        leafletProxy("map") |>
            fitBounds(lng1 = xmin, lat1 = ymin, lng2 = xmax, lat2 = ymax)

        # These coords are in EPSG:4326, but our rasters are EPSG:27700
        extent_4326 <- terra::ext(xmin, xmax, ymin, ymax)
        extent_27700 <- terra::project(extent_4326, from = "EPSG:4326", to = "EPSG:27700")

        # Store the SpatExtent as a reactive value
        reactiveExtent(extent_27700)
    })

    # Recompute raster when update button is clicked
    observeEvent(input$updateButton, {
        persona <- get_persona_from_sliders()
        
        msg <- capture.output(
            valid_persona <- check_valid_persona(persona),
            type = "message"
        )
        output$userInfo <- renderPrint({
            cat(msg, sep = "\n")
        })
        if (!valid_persona) return()

        bbox <- reactiveExtent()

        msg <- capture.output(
            valid_bbox <- check_valid_bbox(bbox),
            type = "message"
        )
        output$userInfo <- renderPrint({
            cat(msg, sep = "\n")
        })
        if (!valid_bbox) return()


        #output$userInfo <- renderText({"Computing Recreational Potential..."}) # nolint

        msg <- capture.output(
            layers <- model::compute_potential(
                persona,
                raster_dir = .raster_dir,
                bbox = bbox
            ),
            type = "message"
        )

        output$userInfo <- renderPrint({
            cat(msg, sep = "\n")
        })

        # Update reactiveLayers with new raster
        reactiveLayers(layers)

        update_map()

    })

    # Update map using cached values when layer selection changes
    observeEvent(input$layerSelect, {
        update_map()
    })

    # Update map using cached values when opacity changes
    observeEvent(input$opacity, {
        update_map()
    })
}

shinyApp(ui = ui, server = server)
