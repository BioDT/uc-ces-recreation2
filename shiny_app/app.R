library(shiny)
library(leaflet)

# setwd(here::here())
print(getwd())
devtools::load_all("../model")
source("about.R")

# UKCEH theming
devtools::source_url("https://github.com/NERC-CEH/UKCEH_shiny_theming/blob/main/theme_elements.R?raw=TRUE")

# Modify theme so buttons are visible...
UKCEH_theme <- bs_add_rules(
    UKCEH_theme,
    ".btn {
    color: black;
    border-color: darkgrey;
    }"
)

.credentials <- data.frame(
    user = Sys.getenv("APP_USERNAME"),
    password = Sys.getenv("APP_PASSWORD")
)

.persona_dir <- "personas"
.example_persona_csv <- file.path(.persona_dir, "examples.csv")
.config <- load_config()
.layer_info <- setNames(.config[["Description"]], .config[["Name"]])
.layer_names <- names(.layer_info)

list_persona_files <- function() {
    return(list.files(path = .persona_dir, pattern = "\\.csv$", full.names = FALSE))
}

list_personas_in_file <- function(file_name) {
    personas <- names(read.csv(file.path(.persona_dir, file_name), nrows = 1))
    return(personas[personas != "index"])
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

ui <- fluidPage(
    theme = UKCEH_theme,
    tags$head(
        tags$style(HTML("
            html, body {height: 100%;}
            #map {height: 80vh !important;}
        "))
    ),
    # Add title, contact address and privacy notice in combined title panel + header
    fluidRow(
        style = "background-color: #f8f9fa;",
        UKCEH_titlePanel("BioDT: Recreational Potential Model"),
    ),
    fluidRow(
        column(
            width = 6,
            fluidRow(
                column(width = 3, actionButton("loadButton", "Load Persona")),
                column(width = 3, actionButton("saveButton", "Save Persona")),
                column(width = 6, actionButton("updateButton", "Update Map"))
            ),
            verbatimTextOutput("userInfo"),
            tabsetPanel(
                tabPanel("About", about_html),
                tabPanel("SLSRA", create_sliders("SLSRA")),
                tabPanel("FIPS_N", create_sliders("FIPS_N")),
                tabPanel("FIPS_I", create_sliders("FIPS_I")),
                tabPanel("Water", create_sliders("Water"))
            ),
        ),
        column(
            width = 6,
            radioButtons(
                "layerSelect",
                "Select Layer",
                choices = list(
                    "SLSRA" = 1,
                    "FIPS_N" = 2,
                    "FIPS_I" = 3,
                    "Water" = 4,
                    "Recreational Potential" = 5
                ),
                selected = 5,
                inline = TRUE
            ),
            leafletOutput("map")
        ),
        tags$div(
            style = "background-color: #f8f9fa; border: 1px solid #ccc; padding: 10px; border-radius: 5px;",
            "© UK Centre for Ecology & Hydrology, 2025",
        )
    )
)

# Add password authorisation
ui <- shinymanager::secure_app(ui)

server <- function(input, output, session) {
    # Check credentials
    # See https://datastorm-open.github.io/shinymanager/
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
    reactiveLoadFile <- reactiveVal("examples.csv")

    # Reactive variable for caching computed raster
    reactiveLayers <- reactiveVal()

    # ------------------------------------------------------ Loading

    # Open a dialogue box to load a new persona
    observeEvent(input$loadButton, {
        showModal(
            modalDialog(
                title = "Load Persona",
                selectInput(
                    "loadFileSelect",
                    "Select existing file",
                    choices = list_persona_files()
                ),
                selectInput(
                    "loadPersonaSelect",
                    "Select persona",
                    choices = NULL
                ),
                footer = tagList(
                    modalButton("Cancel"),
                    actionButton("confirmLoad", "Load")
                )
            )
        )
    })
    observeEvent(input$loadFileSelect, {
        req(input$loadFileSelect)
        reactiveLoadFile(input$loadFileSelect)
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
                    "saveFileSelect",
                    "Select existing file",
                    choices = c("", list_persona_files())
                ),
                textInput("saveFileName", "Or enter a new file name"),
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
        file_name <- if (input$saveFileName != "") input$saveFileName else input$saveFileSelect
        persona_name <- input$savePersonaName

        msg <- capture.output(
            model::save_persona(
                persona = get_persona_from_sliders(),
                csv_path = file.path(.persona_dir, file_name),
                name = persona_name
            ),
            type = "message"
        )

        output$userInfo <- renderPrint({
            cat(msg, sep = "\n")
        })

        removeModal()
    })

    # Initialize Leaflet map
    output$map <- renderLeaflet({
        leaflet() |>
            setView(lng = -4.2026, lat = 56.4907, zoom = 7) |>
            addTiles() |>
            addLegend(pal = palette, values = c(0, 1), title = "Values")
    })


    # --------------------------------------------------------------- Map
    # Grabs cached layers and updates map with current layer selection
    update_map <- function() {
        req(reactiveLayers())

        layers <- reactiveLayers()
        curr_layer <- layers[[as.numeric(input$layerSelect)]]

        leafletProxy("map") |>
            clearImages() |>
            addRasterImage(curr_layer, colors = palette, opacity = 0.8)
    }

    # Recompute raster when update button is clicked
    observeEvent(input$updateButton, {
        persona <- get_persona_from_sliders()

        msg <- capture.output(
            layers <- model::compute_potential(persona, raster_dir = "data/one_hot/"),
            type = "message"
        )

        output$userInfo <- renderPrint({
            cat(msg, sep = "\n")
        })

        # TODO: do this in compute_potential
        layers <- terra::sapp(layers, model::rescale_to_unit_interval)

        # Update reactiveLayers with new raster
        reactiveLayers(layers)

        update_map()
    })

    # Update map using cached values when layer selection changes
    observeEvent(input$layerSelect, {
        update_map()
    })
}

shinyApp(ui = ui, server = server)
