# Define UI for Page 3
ui_page3 <- function() {
  hidden(
  div(
    id = "page3",
    h2("Step 2: Model Parameterization"),
    sidebarLayout(
      sidebarPanel(
        
        actionButton("back2", "Back"),
        actionButton("next3", "Next"),
        
        #### FIPS_N
        
        h3(tags$b("FIPS_N: Natural features that influence the recreational potential")),
        
        h4("This section is about the natural features that influence the potential capacity of land to provide recreational opportunities.  
         Whilst considering this from the view point of your Persona, please score each with a value between 0 and 10"),
        
        h3("FIPS_N: Landform classes"),
        numericInput("FIPS_N_Landform_1", "Foothills", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_2", "Lochs", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_3", "Mountains", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_4", "Terraces", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_5", "Flood plain", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_6", "Beaches / sand dunes", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_7", "Rocks / Scree", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_8", "Depressions", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_9", "Hills", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_10", "Lowlands", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_11", "Rock Walls", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_12", "Uplands", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_13", "Valley sides", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_14", "Valley bottom", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_15", "Built-up areas", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_16", "Saltings", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Landform_17", "Hummocks / mounds / moraines", value = 0, min = 0, max = 10),
        
        h3("FIPS_N: National Forest Inventory"),
        numericInput("FIPS_N_NFI_1", "Non Woodland: Agricultural land", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_2", "Non Woodland: Bare ground/rock", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_3", "Non Woodland: Forest Road or track", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_4", "Non Woodland: Grass", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_5", "Non Woodland: Open Water", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_6", "Non Woodland: Other vegetation", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_7", "Non Woodland: Powerline", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_8", "Non Woodland: Quarry", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_9", "Non Woodland: River", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_10", "Non Woodland: Urban / building", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_11", "Non Woodland: Windfarm", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_12", "Woodland: Assumed Woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_13", "Woodland: Grass", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_14", "Woodland: Ground Prepared for Planting", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_15", "Woodland: Felled", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_16", "Woodland: Shrub Land", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_17", "Woodland: Young Trees", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_18", "Woodland: Mixed - predominantly Conifer", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_19", "Woodland: Broadleaved", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_20", "Woodland: Coppice", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_21", "Woodland: Low Density", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_22", "Woodland: Conifer", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NFI_23", "Woodland: Mixed - predominantly Broadleaved", value = 0, min = 0, max = 10),
        
        h3("FIPS_N: Native Woodland Survey of Scotland"),
        numericInput("FIPS_N_NWSS_1", "Native woodland: Native upland mixed deciduous woodland and scrub", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_2", "Native woodland: Wet woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_3", "Native woodland: Non native", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_4", "Native woodland: Unidentifiable type", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_5", "Native woodland: Scrub", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_6", "Native woodland: Clear fell", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_7", "Native woodland: Lowland mixed deciduous woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_8", "Native woodland: Native pinewood", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_9", "Nearly-native woodland: Native pinewood", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_10", "Nearly-native woodland: Wet woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_11", "Nearly-native woodland: Non native", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_12", "Nearly-native woodland: Clear fell", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_13", "Nearly-native woodland: Unidentifiable type", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_14", "Nearly-native woodland: Native upland mixed deciduous woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_15", "Nearly-native woodland: Lowland mixed deciduous woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_16", "Nearly-native woodland: Scrub", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_17", "Open land habitat", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_18", "Plantations on Ancient Woodland Sites (PAWS): Native pinewood", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_19", "Plantations on Ancient Woodland Sites (PAWS): Wet woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_20", "Plantations on Ancient Woodland Sites (PAWS): Non native", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_21", "Plantations on Ancient Woodland Sites (PAWS): Unidentifiable type", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_22", "Plantations on Ancient Woodland Sites (PAWS): Native upland mixed deciduous woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_23", "Plantations on Ancient Woodland Sites (PAWS): Lowland mixed deciduous woodland", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_24", "Plantations on Ancient Woodland Sites (PAWS): Unidentified", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_NWSS_25", "Plantations on Ancient Woodland Sites (PAWS): Clear fell", value = 0, min = 0, max = 10),
        
        h3("FIPS_N: Soil Type"),
        numericInput("FIPS_N_Soil_1", "Peaty podzols", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_2", "Mineral podzols", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_3", "Peaty gleys", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_4", "Peat", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_5", "Mineral gleys", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_6", "Brown soils", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_7", "Montane soils", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_8", "Immature soils", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_9", "Alluvial soils", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_10", "Calcareous soils", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_11", "Built-up areas", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Soil_12", "Lochs", value = 0, min = 0, max = 10),
        
        h3("FIPS_N: Slope"),
        numericInput("FIPS_N_Slope_1", "Easy almost flat terrain (<3 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_2", "Gentle slope (3-5 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_3", "Medium slope (5-10 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_4", "Steep slope (10-20 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_5", "Very steep slope (20-30 %)", value = 0, min = 0, max = 10),
        numericInput("FIPS_N_Slope_6", "Extremely steep slope (>30 %)", value = 0, min = 0, max = 10),
      
        actionButton("back2", "Back"),
        actionButton("next3", "Next")
      ),
      
      mainPanel()
    )
  )
  )
}