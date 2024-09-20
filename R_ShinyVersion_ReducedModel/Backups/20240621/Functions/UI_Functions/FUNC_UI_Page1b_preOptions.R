# Define UI for Page 1b
ui_page1b <- function() {
  fluidPage(
    hidden(
      div(
        id = "page1b",
        h2("Step 2: Model Parameterization"),
        sidebarLayout(
          sidebarPanel(
            br(),
            textInput("persona_id", "Please enter a suitable ID for your RP Persona:", value = ""),
            actionButton("submit_persona_id", "Save Persona ID"),
            br(),
            textOutput("response_sidebar"),
            br(),
            actionButton("back6", "Back"),
            actionButton("next6", "Next"),# Display response message in sidebar
          ),
          mainPanel(
            # No content in the mainPanel in this configuration
          )
        )
      )
    )
  )
}