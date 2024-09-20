# Define UI for Page 6
ui_page6 <- function() {
  div(
    id = "page6",
    h2("Step 4: Run the Recreational Potential Model"),
    sidebarLayout(
      sidebarPanel(
        actionButton("back5", "Back"),
        actionButton("run_model", "Run Model"), 
        downloadButton("export_tif", "Export Map"),
        sliderInput("transparency", "Adjust Transparency", min = 0, max = 1, value = 0.7, step = 0.1) # Add transparency slider
      ),
      mainPanel(
        leafletOutput("map_output", height = 600),  # Changed plotOutput to leafletOutput
        textOutput("message")
      )
    )
  )
}