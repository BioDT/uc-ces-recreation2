library(shiny)
library(leaflet)

devtools::load_all("../model")

persona <- model::load_persona("persona.csv")


create_sliders <- function(component) {
    layer_names <- names(persona)[startsWith(names(persona), component)]
    sliders <- lapply(layer_names, function(layer_name) {
        sliderInput(
            layer_name,
            label = layer_name, # TODO: fix
            min = 0,
            max = 10,
            value = persona[[layer_name]],
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
        tags$style(HTML("html, body {height: 100%;} #map {height: 80vh !important;}"))
    ),
    titlePanel("BioDT - Scotland Recreational Model"),
    fluidRow(
        column(
            width = 6,
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


    # Recompute raster when update button is clicked
    observeEvent(input$updateButton, {
        persona_ <- sapply(
            names(persona),
            function(layer_name) input[[layer_name]],
            USE.NAMES = TRUE
        )
        layers <- model::compute_potential(persona_, raster_dir = "data/one_hot/") |>
            model::rescale_to_unit_interval() # TODO: do this in compute_potential

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
