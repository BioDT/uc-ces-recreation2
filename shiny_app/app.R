library(shiny)
library(leaflet)

# setwd(here::here())
print(getwd())
devtools::load_all("../model")

.persona_dir <- "personas"

.persona <- model::load_persona(file.path(.persona_dir, "template.csv"))


list_persona_files <- function() {
    return(list.files(path = .persona_dir, pattern = "\\.csv$", full.names = FALSE))
}

list_personas_in_file <- function(csv_file) {
    personas <- names(read.csv(csv_file, nrows = 1))
    return(personas[personas != "index"])
}

create_sliders <- function(component) {
    layer_names <- names(.persona)[startsWith(names(.persona), component)]
    sliders <- lapply(layer_names, function(layer_name) {
        sliderInput(
            layer_name,
            label = layer_name, # TODO: fix
            min = 0,
            max = 10,
            value = .persona[[layer_name]],
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
    tags$head(
        tags$style(HTML("
            html, body {height: 100%;}
            #map {height: 80vh !important;}
            .load-row {display: flex; align-items: flex-end;}
        "))
    ),
    titlePanel("BioDT - Scotland Recreational Model"),
    fluidRow(
        column(
            width = 6,
            fluidRow(
                column(
                    width = 6,
                    selectInput("fileSelect", "Select File", NULL)
                ),
                column(
                    width = 4,
                    selectInput("personaSelect", "Select Persona", NULL)
                ),
                column(
                    width = 1,
                    actionButton("loadButton", "Load")
                ),
                column(
                    width = 1,
                    actionButton("saveButton", "Save")
                )
            ),
            verbatimTextOutput("saveInfo"),
            tabsetPanel(
                tabPanel("SLSRA", create_sliders("SLSRA")),
                tabPanel("FIPS_N", create_sliders("FIPS_N")),
                tabPanel("FIPS_I", create_sliders("FIPS_I")),
                tabPanel("Water", create_sliders("Water"))
            )
        ),
        column(
            width = 6,
            actionButton("updateButton", "Update Map"),
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
        )
    )
)

server <- function(input, output, session) {
    # Initialize Leaflet map
    output$map <- renderLeaflet({
        leaflet() |>
            setView(lng = -4.2026, lat = 56.4907, zoom = 7) |>
            addTiles() |>
            addLegend(pal = palette, values = c(0, 1), title = "Values")
    })

    # Reactive variable for caching layers
    reactiveLayers <- reactiveVal()

    # Grabs cached layers and updates map with current layer selection
    update_map <- function() {
        req(reactiveLayers())

        layers <- reactiveLayers()
        curr_layer <- layers[[as.numeric(input$layerSelect)]]

        leafletProxy("map") |>
            clearImages() |>
            addRasterImage(curr_layer, colors = palette, opacity = 0.8)
    }

    # Update file selection (any time user clicks 'save')
    update_file_choices <- function() {
        files <- list_persona_files()
        updateSelectInput(session, "fileSelect", choices = setNames(files, basename(files)))
    }

    update_persona_choices <- function() {
        req(input$fileSelect)
        personas <- list_personas_in_file(file.path(.persona_dir, input$fileSelect))
        updateSelectInput(session, "personaSelect", choices = personas)
    }

    # Load initial file choices
    update_file_choices()

    get_persona_from_sliders <- function() {
        persona <- sapply(
            names(.persona),
            function(layer_name) input[[layer_name]],
            USE.NAMES = TRUE
        )
        return(persona)
    }

    # Recompute raster when update button is clicked
    observeEvent(input$updateButton, {
        persona <- get_persona_from_sliders()
        layers <- model::compute_potential(persona, raster_dir = "data/one_hot/")

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

    observeEvent(input$fileSelect, {
        update_persona_choices()
    })

    # Load a new persona
    observeEvent(input$loadButton, {
        req(input$fileSelect)
        req(input$personaSelect)

        loaded_persona <- model::load_persona(
            file.path(.persona_dir, input$fileSelect),
            input$personaSelect
        )

        # Apply new persona to sliders
        lapply(names(loaded_persona), function(layer_name) {
            updateSliderInput(session, inputId = layer_name, value = loaded_persona[[layer_name]])
        })
    })

    observeEvent(input$saveButton, {
        req(input$fileSelect)
        req(input$personaSelect)

        showModal(
            modalDialog(
                title = "Save Persona",
                textInput("saveFileName", "Enter file name", value = input$fileSelect),
                textInput("savePersonaName", "Enter persona name", value = input$personaSelect),
                footer = tagList(
                    modalButton("Cancel"),
                    actionButton("confirmSave", "Save")
                )
            )
        )
    })

    observeEvent(input$confirmSave, {
        model::save_persona(
            persona = get_persona_from_sliders(),
            csv_path = file.path(.persona_dir, input$saveFileName),
            name = input$savePersonaName
        )
        update_file_choices()

        output$saveInfo <- renderPrint({
            paste("Saving persona '", input$savePersonaName, "' to file '", input$saveFileName)
        })

        removeModal()
    })
}

shinyApp(ui = ui, server = server)
