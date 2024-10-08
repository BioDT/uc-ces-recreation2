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
        
        tags$hr(style="border-color: black; border-width: 3px;"), # horizontal line
        
        #### Water
        
        h3(tags$b("Water: The influence of water on the recreational potential")),
        
        br(),  # blank line
        
        h4("The proximity to water (lakes, rivers) has been shown to be especially important for recreation.  
         Whilst considering the following from the view point of your Persona, please score each with a value between 0 and 10"),
        
        br(),  # blank line
        
        # Model parameterization - should be only be able to add values between 0 and 10!
        
        h3("The presence of Rivers"),
        numericInput("Water_Rivers_2", "Unnamed minor stream or tributary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_4", "Named minor stream or tributary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_1", "Minor river or tributary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_3", "Major river or tributary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_6", "Tidal river or estuary", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_5", "Lake", value = 0, min = 0, max = 10),
        numericInput("Water_Rivers_7", "Canal", value = 0, min = 0, max = 10),
        hr(),  # feint horizontal line
        
        br(),  # blank line
        h3("The presence of Lakes"),
        numericInput("Water_Lakes_1", "Pond", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_2", "Lochan", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_3", "Small Lochs", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_4", "Medium Lochs", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_5", "Large Lochs", value = 0, min = 0, max = 10),
        numericInput("Water_Lakes_6", "Major Lochs", value = 0, min = 0, max = 10),
        
        tags$hr(style="border-color: black; border-width: 3px;"), # thick black horizontal line
       
       # Export, sumbit, fwd/back  buttons etc...
       # textInput("rename_persona_id", "Rename Persona ID (Optional where values have been edited)?", value = ""),
       actionButton("submit", "Submit"),
       downloadButton("export_responses", "Export Responses"),
       textOutput("response"),
       actionButton("back4", "Back"),
       actionButton("next5", "Next"),
        width = 6
      ),
      
      mainPanel()
    )
#  )
  )
}