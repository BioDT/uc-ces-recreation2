# Define UI for Page 2
ui_page2 <- function() {
  hidden(
  div(
    id = "page2",
    h2("Step 2: Model Parameterization"),
    sidebarLayout(
      sidebarPanel(
        
        actionButton("back1", "Back"),
        actionButton("next2", "Next"),
        
        #textInput("persona_id", "Please enter a suitable ID for your RP Persona:", value = ""),
        #tags$script("document.getElementById('persona_id').addEventListener('input', function(event) { this.value = this.value.toUpperCase(); });"),
        
        h3(tags$b("SLSRA: The Suitability of land to support RP")),
        
        h4("This section is about the suitability of land to support RP based on its natural features (its degree of naturalness).  
         Whilst considering this from the view point of your Persona, please score each with a value between 0 and 10"),
        
        ### SLSRA
        
        h3("SLSRA: Land Cover Types"),
        numericInput("SLSRA_LCM_1", "Alpine and subalpine grassland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_2", "Arable land and market gardens", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_3", "Arctic, alpine and subalpine scrub", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_4", "Bare field / exposed soil", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_5", "Base-rich fens and calcareous spring mires", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_6", "Broadleaved deciduous woodland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_7", "Built-up area", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_8", "Coastal dunes and sandy shore", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_9", "Coastal shingle", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_10", "Dry grassland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_11", "Freshwater", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_12", "Inland cliffs, rock pavements and outcrops", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_13", "Lines of trees, small planted woodlands, early-stage woodland and coppice", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_14", "Littoral sediment / saltmarsh", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_15", "Mesic grassland (Pastures & Hay meadows)", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_16", "Mixed deciduous and coniferous woodland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_17", "Non-native coniferous plantation", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_18", "Raised and blanket bog", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_19", "Riverine and fen scrubs", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_20", "Rock cliffs, ledges and shores", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_21", "Scots pine woodland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_22", "Screes", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_23", "Seasonally wet and wet grassland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_24", "Temperate montane scrub", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_25", "Temperate shrub heathland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_26", "Valley mires, poor fens and transition mires", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_27", "Windthrown woodland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_LCM_28", "Woodland fringes and clearings and tall forb stands", value = 0, min = 0, max = 10),
        
        h3("SLSRA: Historic Land Use Assessment - historic land classes"),
        numericInput("SLSRA_HLUA_1", "Agriculture: Crofting & Smallholdings", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_2", "Agriculture: Modern large scale farming", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_3", "Energy, Extraction and Waste: Commercial mining and mineral extraction", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_4", "Energy, Extraction and Waste: Commercial power generation", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_5", "Energy, Extraction and Waste: Landfill", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_6", "Energy, Extraction and Waste: Traditional Peat Cutting", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_7", "Forestry: Managed Woodland", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_8", "Forestry: Plantation", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_9", "Historic designed landscapes (e.g. parkland)", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_10", "Leisure and Recreation: Golf Course", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_11", "Leisure and Recreation: Recreation Area", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_12", "Leisure and Recreation: Ski Area", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_13", "Military Site", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_14", "Moorland and Rough Grazing", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_15", "Religious site", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_16", "Settlements: Historic town", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_17", "Settlements: Historic village", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_18", "Settlements: Industrial area", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_19", "Settlements: Urban area", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_20", "Transport infrastructure (Airports, railways, roads)", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_21", "Water: Freshwater", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_22", "Water: Reed beds", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_23", "Water: Seashore", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HLUA_24", "Water: Shellfish farm", value = 0, min = 0, max = 10),
        
        h4(tags$b("The remaining SLSRA inputs are various land designations or different types of publicly accessible 
         reserves.  Please consider how relevant each is to your Persona, and score with a value between 0 and 10")),
        
        h3("SLSRA: areas of High Nature Value farming (HNV)"),
        numericInput("SLSRA_HNV_1", "Farmland is NOT designated as HNV", value = 0, min = 0, max = 10),
        numericInput("SLSRA_HNV_2", "Farmland IS designated as HNV", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a Country Park"),
        numericInput("SLSRA_CP_1", "Land is NOT designated as a Country Park", value = 0, min = 0, max = 10),
        numericInput("SLSRA_CP_2", "Land IS designated as a Country Park", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a National Nature Reserve (NNR)"),
        numericInput("SLSRA_NNR_1", "Land is NOT designated as a National Nature Reserve", value = 0, min = 0, max = 10),
        numericInput("SLSRA_NNR_2", "Land IS designated as a National Nature Reserve", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a National Park"),
        numericInput("SLSRA_NP_1", "Land is NOT designated as a National Park", value = 0, min = 0, max = 10),
        numericInput("SLSRA_NP_2", "Land IS designated as a National Park", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a Nature Reserve"),
        numericInput("SLSRA_NR_1", "Land is NOT designated as a Nature Reserve", value = 0, min = 0, max = 10),
        numericInput("SLSRA_NR_2", "Land IS designated as a Nature Reserve", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a Regional Park"),
        numericInput("SLSRA_RP_1", "Land is NOT designated as a Regional Park", value = 0, min = 0, max = 10),
        numericInput("SLSRA_RP_2", "Land IS designated as a Regional Park", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a RSPB Reserve"),
        numericInput("SLSRA_RSPB_1", "Land is NOT designated as a RSPB Reserve", value = 0, min = 0, max = 10),
        numericInput("SLSRA_RSPB_2", "Land IS designated as a RSPB Reserve", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a Special Area of Conservation (SAC)"),
        numericInput("SLSRA_SAC_1", "Land is NOT designated as a Special Area of Conservation (SAC)", value = 0, min = 0, max = 10),
        numericInput("SLSRA_SAC_2", "Land IS designated as a Special Area of Conservation (SAC)", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a Special Protection Area (SPA)"),
        numericInput("SLSRA_SPA_1", "Land is NOT designated as a Special Protection Area (SPA)", value = 0, min = 0, max = 10),
        numericInput("SLSRA_SPA_2", "Land IS designated as a Special Protection Area (SPA)", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a Site of Special Scientific Interest (SSSI)"),
        numericInput("SLSRA_SSSI_1", "Land is NOT designated as a Site of Special Scientific Interest (SSSI))", value = 0, min = 0, max = 10),
        numericInput("SLSRA_SSSI_2", "Land IS designated as a Site of Special Scientific Interest (SSSI)", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a Scottish Wildlife Trust Reserve"),
        numericInput("SLSRA_SWT_1", "Land is NOT designated as a Scottish Wildlife Trust Reserve", value = 0, min = 0, max = 10),
        numericInput("SLSRA_SWT_2", "Land IS designated as a Scottish Wildlife Trust Reserve", value = 0, min = 0, max = 10),
        
        h3("SLSRA: areas designated as a Wild Land Area"),
        numericInput("SLSRA_WLA_1", "Land is NOT designated as a Wild Land Area", value = 0, min = 0, max = 10),
        numericInput("SLSRA_WLA_2", "Land IS designated as a Wild Land Area", value = 0, min = 0, max = 10),
        
        actionButton("back1", "Back"),
        actionButton("next2", "Next")
      ),
      
      mainPanel()
    )
  )
  )
}
