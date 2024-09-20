# Define UI for Page 1
ui_page1 <- function() {
  div(
    id = "page1",
    h2("Step 1: Defining an area of Interest"),
    sidebarLayout(
      sidebarPanel(
        useShinyjs(),
        radioButtons("file_option", "Do you wish to upload a new shapefile, or select from existing repository:",
                     choices = c("Upload New Shapefile" = "upload", "Select Existing Shapefile" = "select")),
        
        # Code for uploading new shapefile
        conditionalPanel(
          condition = "input.file_option == 'upload'",
          textInput("shapefile_name", "Enter name for the shapefile:", ""),
          fileInput("shapefile", "Upload zipped shapefile:", accept = c(".zip")),
          actionButton("upload", "Upload and Display")
        ),
        
        # Code for selecting existing shapefile
        conditionalPanel(
          condition = "input.file_option == 'select'",
          selectInput("existing_shapefile", "Select existing shapefile:", choices = NULL),
          actionButton("load_existing", "Load Selected Shapefile")
        ),
        
        br(),
        br(),
        actionButton("next1", "Next"),
        width = 6
      ),
      mainPanel(
        leafletOutput("map", height = 800),
        textOutput("message"),
        width = 6
      )
    )
  )
}