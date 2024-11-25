# Define UI for Page 5
ui_page5 <- function() {
#  hidden(
  div(
    id = "page5",
    h2("Step 3: Persona Parameterization"),
    sidebarLayout(
      sidebarPanel(
        
        actionButton("back4", "Back"),
        actionButton("next5", "Next"),
        
        #### Water
        
        h3(tags$b("Water: The influence of water on the recreational potential")),
        
        h4("The proximity to water (lakes, rivers) has been shown to be especially important for recreation.  
         Whilst considering the following from the view point of your Persona, please score each with a value between 0 and 10"),
        
        h3("Water: The presence of Rivers"),
        numericInput("Water_Rivers_1", "Minor river or tributary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_2", "Unnamed minor stream or tributary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_3", "Major river or tributary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_4", "Named minor stream or tributary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_5", "Lake", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_6", "Tidal river or estuary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_7", "Canal", value = 0, min = 0, max = 10),
        
        h3("Water: The presence of Lakes"),
        numericInput("Water_Lakes_1", "Pond", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_2", "Lochan", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_3", "Small Lochs", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_4", "Medium Lochs", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_5", "Large Lochs", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_6", "Major Lochs", value = 0, min = 0, max = 10),
      
        actionButton("back4", "Back"),
        actionButton("submit", "Submit"),
        downloadButton("export_responses", "Export Responses"),
        textOutput("response"),
        actionButton("next5", "Next"),
        width = 6
      ),
      
      mainPanel()
    )
#  )
  )
}