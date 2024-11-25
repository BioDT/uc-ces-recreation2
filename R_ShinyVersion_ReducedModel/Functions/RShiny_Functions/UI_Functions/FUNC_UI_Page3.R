# Define UI for Page 3
ui_page3 <- function() {
#  hidden(
  div(
    id = "page3",
    h2("Step 3: Persona Parameterization"),
    sidebarLayout(
      sidebarPanel(
        
        actionButton("back2", "Back"),
        actionButton("next3", "Next"),
        
        tags$hr(style="border-color: black; border-width: 3px;"), # horizontal line
        
        #### FIPS_N
        
        h3(tags$b("FIPS_N: Natural features that influence the recreational potential")),
        
        br(),  # This adds a blank line
        
        h4("This section is about the natural features that influence the potential capacity of land to provide recreational opportunities.  
         Whilst considering this from the view point of your Persona, please score each with a value between 0 and 10"),
        
        br(),  # This adds a blank line
        
        # Model parameterization - should be only be able to add values between 0 and 10!
        
        h3("Landform classes"),
        numericInput("FIPS_N_Landform_1", "Foothills", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_2", "Mountains", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_3", "Terraces", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_4", "Flood plain", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_5", "Beaches / sand dunes", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_6", "Rocks / Scree", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_7", "Depressions", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_8", "Hills", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_9", "Lowlands", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_10", "Rock Walls", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_11", "Uplands", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_12", "Valley sides", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_13", "Valley bottom", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_14", "Built-up areas", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_15", "Saltings", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_16", "Hummocks / mounds / moraines", value = 0, min = 0, max = 10),
        
        hr(),  # This adds a feint horizontal line
        br(),  # This adds a blank line
        
        h3("Soil Type"),
        numericInput("FIPS_N_Soil_1", "Peat / Organic Soils", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_2", "Mineral Soils", value = 0, min = 0, max = 10),
        
        hr(),  # This adds a feint horizontal line
        br(),  # This adds a blank line
        
        h3("Terrain: Slope"),
        numericInput("FIPS_N_Slope_1", "Easy almost flat terrain (<3 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_2", "Gentle slope (3-5 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_3", "Medium slope (5-10 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_4", "Steep slope (10-20 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_5", "Very steep slope (20-30 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_6", "Extremely steep slope (>30 %)", value = 0, min = 0, max = 10),
        
        tags$hr(style="border-color: black; border-width: 3px;"), # horizontal line
      
        actionButton("back2", "Back"),
        actionButton("next3", "Next"),
        width = 6
      ),
      
      mainPanel()
    )
#  )
  )
}