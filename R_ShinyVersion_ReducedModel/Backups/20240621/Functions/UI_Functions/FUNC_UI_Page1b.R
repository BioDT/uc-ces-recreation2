# Define UI for Page 1b
ui_page1b <- function() {
  fluidPage(
    useShinyjs(),  # Include shinyjs
    hidden(
      div(
        id = "page1b",
        h2("Step 2: Model Parameterization"),
        sidebarLayout(
          sidebarPanel(
            br(),
            selectInput("file_option", "Select Option:", choices = c("", "Create New Persona" = "create_new", "Load Existing Persona" = "load_existing"), selected = ""),
            conditionalPanel(
              condition = "input.file_option == 'create_new'",
              textInput("persona_id", "Please enter a suitable ID for your RP Persona:", value = ""),
              actionButton("submit_persona_id", "Save Persona ID")
            ),
            conditionalPanel(
              condition = "input.file_option == 'load_existing'",
              selectInput("existing_persona_file", "Choose Existing Persona File:", choices = NULL),
              actionButton("load_existing_persona", "Load")
            ),
            br(),
            textOutput("response_sidebar"),
            br(),
            actionButton("back6", "Back"),
            actionButton("next6", "Next")
          ),
          mainPanel(
            # No content in the mainPanel in this configuration
          )
        )
      )
    )
  )
}