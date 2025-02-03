library(shiny)

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

plot_potential <- function(persona_) {
    rasters <- model::compute_potential(persona_, raster_dir = "data/one_hot/")
    terra::plot(rasters[["Water"]])
}

ui <- fluidPage(
    titlePanel("BioDT - Scotland Recreational Model"),
    fluidRow(
        column(
            width = 6,
            tabsetPanel(
                tabPanel(
                    "SLSRA",
                    create_sliders("SLSRA")
                ),
                tabPanel(
                    "FIPS_N",
                    create_sliders("FIPS_N")
                ),
                tabPanel(
                    "FIPS_I",
                    create_sliders("FIPS_I")
                ),
                tabPanel(
                    "Water",
                    create_sliders("Water")
                )
            )
        ),
        column(
            width = 6,
            actionButton("computeButton", "Compute"),
            plotOutput("potential_heatmap")
        )
    )
)

server <- function(input, output) {
    # Create reactive expression to store updated persona values
    persona_reactive <- eventReactive(input$computeButton, {
        sapply(
            names(persona),
            function(layer_name) input[[layer_name]],
            USE.NAMES = TRUE
        )
    })

    output$potential_heatmap <- renderPlot({
        plot_potential(persona_reactive())
    })
}

shinyApp(ui = ui, server = server)
