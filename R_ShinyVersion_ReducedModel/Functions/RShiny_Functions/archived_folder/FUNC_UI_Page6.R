# Define UI for Page 6
ui_page6 <- function() {
#  hidden(
    div(
      id = "page6",
      h2("Step 4: Run the Recreational Potential Model"),
      sidebarLayout(
        sidebarPanel(
            #style = "margin-top: 0; padding-top: 0;",
            #textOutput("shapefile_name_output"),
            #textOutput("persona_id_output"),
            actionButton("back5", "Back"),
            actionButton("run_model", "Run Model"), 
            downloadButton("export_tif", "Export Map")
        ),
        mainPanel(
          plotOutput("raster_output"),
          textOutput("message")
        )
      )
    )
#  )
}

