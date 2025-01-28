# Define UI for Page 4
ui_page4 <- function() {
#  hidden(
  div(
    id = "page4",
    h2("Step 3: Persona Parameterization"),
    sidebarLayout(
      sidebarPanel(
        
        actionButton("back3", "Back"),
        actionButton("next4", "Next"),
        
        tags$hr(style="border-color: black; border-width: 3px;"), # horizontal line
        
        ##### FIPS_I
        
        h3(tags$b("FIPS_I: Infrastructure features that influence the recreational potential ")),
        
        br(),  # This adds a blank line
        
        h4("This section is about the infrastructure features that influence the potential capacity of land to provide recreational opportunities.  
         Whilst considering this from the view point of your Persona, please score each with a value between 0 and 10"),
        
        br(),  # This adds a blank line
        
        # Model parameterization - should be only be able to add values between 0 and 10!
        
        h3("Road and Track Types"),
        numericInput("FIPS_I_RoadsTracks_1", "Road type: Motorway", value = 0, min = 0, max = 10),
        numericInput("FIPS_I_RoadsTracks_2", "Road type: A Road", value = 0, min = 0, max = 10),
        numericInput("FIPS_I_RoadsTracks_3", "Road type: B Road", value = 0, min = 0, max = 10),
        numericInput("FIPS_I_RoadsTracks_4", "Road type: Minor / local road", value = 0, min = 0, max = 10),
        numericInput("FIPS_I_RoadsTracks_5", "Road type: Access roads / Track", value = 0, min = 0, max = 10),
        hr(),  # This adds a feint horizontal line
        
        br(),  # This adds a blank line
        h3("National Cycle Network Surface Types"),
        numericInput("FIPS_I_NationalCycleNetwork_1", "On Road: Paved Surface", value = 0, min = 0, max = 10),
        numericInput("FIPS_I_NationalCycleNetwork_4", "On Road: Unpaved Surface", value = 0, min = 0, max = 10),
        numericInput("FIPS_I_NationalCycleNetwork_2", "Traffic Free: Unpaved Surface", value = 0, min = 0, max = 10),
        numericInput("FIPS_I_NationalCycleNetwork_3", "Traffic Free: Paved Surface", value = 0, min = 0, max = 10),
        hr(),  # This adds a feint horizontal line
        
        br(),  # This adds a blank line
        h3("Presence of Local Path Network"),
        numericInput("FIPS_I_LocalPathNetwork_2", "Paths Present", value = 0, min = 0, max = 10),
        
        tags$hr(style="border-color: black; border-width: 3px;"), # horizontal line
      
        actionButton("back3", "Back"),
        actionButton("next4", "Next"),
        width = 6
      ),
      
      mainPanel()
    )
#  )
  )
}