# Define UI for Page 1
ui_page1 <- function() {
  div(
    id = "page1",
    h2("Step 1: Defining an area of Interest"),
    sidebarLayout(
      sidebarPanel(
        textInput("shapefile_name", "Enter name for the shapefile:", ""),
        fileInput("shapefile", "Upload zipped shapefile:",
                  accept = c(".zip")),
        actionButton("upload", "Upload and Display"),
        br(),
        br(),
        br(),
        selectInput("existing_shapefile", "OR, Select existing shapefile:", choices = NULL),
        actionButton("load_existing", "Load Selected Shapefile"),
        actionButton("next1", "Next")
      ),
      mainPanel(
        leafletOutput("map", height = 800),
        textOutput("message")
      )
    )
  )
}