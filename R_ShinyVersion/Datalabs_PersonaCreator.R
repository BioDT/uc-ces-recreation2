rm(list=ls())

library(shiny)

# Define UI for survey
ui <- fluidPage(
  titlePanel("Survey form for Parameterizing the Scotland Recreational Potential (RP) Model"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("persona_id", "Enter your Persona ID (2 digits, letters only):", value = ""),
      tags$script("document.getElementById('persona_id').addEventListener('input', function(event) { this.value = this.value.toUpperCase(); });"),
      
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
      
      ##### FIPS_I
      
      h3(tags$b("FIPS_I: Infrastructure features that influence the recreational potential ")),
      
      h4("This section is about the infrastructure features that influence the potential capacity of land to provide recreational opportunities.  
         Whilst considering this from the view point of your Persona, please score each with a value between 0 and 10"),
      
      h3("FIPS_I: Road and Track Types"),
      numericInput("FIPS_I_RoadsTracks_1", "Road type: Motorway", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_RoadsTracks_2", "Road type: A Road", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_RoadsTracks_3", "Road type: B Road", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_RoadsTracks_4", "Road type: Minor / local road", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_RoadsTracks_5", "Road type: Access roads / Track", value = 0, min = 0, max = 10),
      
      h3("FIPS_I: National Cycle Network Surface Types"),
      
      numericInput("FIPS_I_NationalCycleNetwork_1", "On Road: Paved Surface", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NationalCycleNetwork_4", "On Road: Unpaved Surface", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NationalCycleNetwork_2", "Traffic Free: Unpaved Surface", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NationalCycleNetwork_3", "Traffic Free: Paved Surface", value = 0, min = 0, max = 10),
      
      h3("FIPS_I: National Forest Estate Recreational Route Types"),
      numericInput("FIPS_I_NFERR_1", "Cycling: Downhill", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_2", "Cycling: Cross country", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_3", "Cycling: Forest Road or similar", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_4", "Walking: Easy", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_5", "Walking: Moderate", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_6", "Walking: Difficult", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_7", "Cross Country Ski", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_8", "Equestrian", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_9", "Forest Drive", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERR_10", "Access road", value = 0, min = 0, max = 10),
      
      h3("FIPS_I: National Forest Estate Recreational Areas Asset Types"),
      numericInput("FIPS_I_NFERA_1", "Other", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_2", "Wildlife hide", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_3", "Catering", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_4", "BBQ Area", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_5", "Shelter", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_6", "Play area", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_7", "Heritage Building", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_8", "Ponds/Lakes", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_9", "Education", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_10", "Visitor Centre", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_11", "Car Parking", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_12", "Picnic area", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_13", "Toilet", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_14", "Accommodation", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_15", "Car parking - Layby", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_16", "Visitor Areas - Event space", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_NFERA_17", "Acitivty / Sports area", value = 0, min = 0, max = 10),
      
      h3("FIPS_I: Local Path Network Presence"),
      numericInput("FIPS_I_LocalPathNetwork_1", "No Paths Present", value = 0, min = 0, max = 10),
      numericInput("FIPS_I_LocalPathNetwork_2", "Paths Present", value = 0, min = 0, max = 10),
      
      #### Water
      
      h3(tags$b("Water: The influence of water the recreational potential")),
      
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
      
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      textOutput("response")
    )
  )
)

# Define server logic to save responses
server <- function(input, output) {
  observeEvent(input$submit, {
    # Ensure Persona ID is provided
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Define paths to CSV files
    file_path_FIPS_I_RoadsTracks <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_I/FIPS_I_RoadsTracks.csv"
    file_path_FIPS_I_NationalCycleNetwork <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_I/FIPS_I_NationalCycleNetwork.csv"
    file_path_FIPS_I_NFERR <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_I/FIPS_I_NFERR.csv"
    file_path_FIPS_I_NFERA <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_I/FIPS_I_NFERA.csv"
    file_path_FIPS_I_LocalPathNetwork <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_I/FIPS_I_LocalPathNetwork.csv"
    
    file_path_FIPS_N_Landform <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_N/FIPS_N_Landform.csv"
    file_path_FIPS_N_NFI <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_N/FIPS_N_NFI.csv"
    file_path_FIPS_N_NWSS <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_N/FIPS_N_NWSS.csv"
    file_path_FIPS_N_Soil <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_N/FIPS_N_Soil.csv"
    file_path_FIPS_N_Slope <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_N/slope/FIPS_N_Slope.csv"
    
    file_path_Water_Lakes <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/Water/Water_Lakes.csv"
    file_path_Water_Rivers <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/Water/Water_Rivers.csv"
    
    file_path_SLSRA_CP <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_CP.csv"
    file_path_SLSRA_HLUA <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_HLUA.csv"
    file_path_SLSRA_HNV <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_HNV.csv"
    file_path_SLSRA_LCM <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_LCM.csv"
    file_path_SLSRA_NNR <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_NNR.csv"
    file_path_SLSRA_NP <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_NP.csv"
    file_path_SLSRA_NR <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_NR.csv"
    file_path_SLSRA_RP <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_RP.csv"
    file_path_SLSRA_RSPB <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_RSPB.csv"
    file_path_SLSRA_SAC <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_SAC.csv"
    file_path_SLSRA_SPA <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_SPA.csv"
    file_path_SLSRA_SSSI <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_SSSI.csv"
    file_path_SLSRA_SWT <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_SWT.csv"
    file_path_SLSRA_WLA <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA/SLSRA_WLA.csv"
    
    # Function to update a CSV file
    update_csv <- function(file_path, questions, responses, persona_id) {
      if (!file.exists(file_path)) {
        stop(paste("The file", file_path, "does not exist."))
      }
      data <- read.csv(file_path, stringsAsFactors = FALSE, check.names = FALSE)
      
      if (persona_id %in% colnames(data)) {
        output$response <- renderText("This Persona ID already exists. Please use a different one.")
        return()
      }
      
      data[[persona_id]] <- NA  # Initialize new column with NA
      for (question in names(responses)) {
        row_index <- which(data[, 1] == question)
        if (length(row_index) > 0) {
          data[row_index, persona_id] <- responses[question]
        }
      }
      
      write.csv(data, file_path, row.names = FALSE, na = "")
    }
    
    # SLSRA
    # SLSRA_LCM responses
    questions_SLSRA_LCM <- c(
      "SLSRA_LCM_1",
      "SLSRA_LCM_2",
      "SLSRA_LCM_3",
      "SLSRA_LCM_4",
      "SLSRA_LCM_5",
      "SLSRA_LCM_6",
      "SLSRA_LCM_7",
      "SLSRA_LCM_8",
      "SLSRA_LCM_9",
      "SLSRA_LCM_10",
      "SLSRA_LCM_11",
      "SLSRA_LCM_12",
      "SLSRA_LCM_13",
      "SLSRA_LCM_14",
      "SLSRA_LCM_15",
      "SLSRA_LCM_16",
      "SLSRA_LCM_17",
      "SLSRA_LCM_18",
      "SLSRA_LCM_19",
      "SLSRA_LCM_20",
      "SLSRA_LCM_21",
      "SLSRA_LCM_22",
      "SLSRA_LCM_23",
      "SLSRA_LCM_24",
      "SLSRA_LCM_25",
      "SLSRA_LCM_26",
      "SLSRA_LCM_27",
      "SLSRA_LCM_28"
    )
    responses_SLSRA_LCM <- c(
      input$SLSRA_LCM_1,
      input$SLSRA_LCM_2,
      input$SLSRA_LCM_3,
      input$SLSRA_LCM_4,
      input$SLSRA_LCM_5,
      input$SLSRA_LCM_6,
      input$SLSRA_LCM_7,
      input$SLSRA_LCM_8,
      input$SLSRA_LCM_9,
      input$SLSRA_LCM_10,
      input$SLSRA_LCM_11,
      input$SLSRA_LCM_12,
      input$SLSRA_LCM_13,
      input$SLSRA_LCM_14,
      input$SLSRA_LCM_15,
      input$SLSRA_LCM_16,
      input$SLSRA_LCM_17,
      input$SLSRA_LCM_18,
      input$SLSRA_LCM_19,
      input$SLSRA_LCM_20,
      input$SLSRA_LCM_21,
      input$SLSRA_LCM_22,
      input$SLSRA_LCM_23,
      input$SLSRA_LCM_24,
      input$SLSRA_LCM_25,
      input$SLSRA_LCM_26,
      input$SLSRA_LCM_27,
      input$SLSRA_LCM_28
    )
    names(responses_SLSRA_LCM) <- questions_SLSRA_LCM
    
    # SLSRA_HLUA responses
    questions_SLSRA_HLUA <- c(
      "SLSRA_HLUA_1",
      "SLSRA_HLUA_2",
      "SLSRA_HLUA_3",
      "SLSRA_HLUA_4",
      "SLSRA_HLUA_5",
      "SLSRA_HLUA_6",
      "SLSRA_HLUA_7",
      "SLSRA_HLUA_8",
      "SLSRA_HLUA_9",
      "SLSRA_HLUA_10",
      "SLSRA_HLUA_11",
      "SLSRA_HLUA_12",
      "SLSRA_HLUA_13",
      "SLSRA_HLUA_14",
      "SLSRA_HLUA_15",
      "SLSRA_HLUA_16",
      "SLSRA_HLUA_17",
      "SLSRA_HLUA_18",
      "SLSRA_HLUA_19",
      "SLSRA_HLUA_20",
      "SLSRA_HLUA_21",
      "SLSRA_HLUA_22",
      "SLSRA_HLUA_23",
      "SLSRA_HLUA_24"
    )
    responses_SLSRA_HLUA <- c(
      input$SLSRA_HLUA_1,
      input$SLSRA_HLUA_2,
      input$SLSRA_HLUA_3,
      input$SLSRA_HLUA_4,
      input$SLSRA_HLUA_5,
      input$SLSRA_HLUA_6,
      input$SLSRA_HLUA_7,
      input$SLSRA_HLUA_8,
      input$SLSRA_HLUA_9,
      input$SLSRA_HLUA_10,
      input$SLSRA_HLUA_11,
      input$SLSRA_HLUA_12,
      input$SLSRA_HLUA_13,
      input$SLSRA_HLUA_14,
      input$SLSRA_HLUA_15,
      input$SLSRA_HLUA_16,
      input$SLSRA_HLUA_17,
      input$SLSRA_HLUA_18,
      input$SLSRA_HLUA_19,
      input$SLSRA_HLUA_20,
      input$SLSRA_HLUA_21,
      input$SLSRA_HLUA_22,
      input$SLSRA_HLUA_23,
      input$SLSRA_HLUA_24
    )
    names(responses_SLSRA_HLUA) <- questions_SLSRA_HLUA
    
    # SLSRA_HNV responses
    questions_SLSRA_HNV <- c(
      "SLSRA_HNV_1",
      "SLSRA_HNV_2"
    )
    responses_SLSRA_HNV <- c(
      input$SLSRA_HNV_1,
      input$SLSRA_HNV_2
    )
    names(responses_SLSRA_HNV) <- questions_SLSRA_HNV
    
    # SLSRA_CP responses
    questions_SLSRA_CP <- c(
      "SLSRA_CP_1",
      "SLSRA_CP_2"
    )
    responses_SLSRA_CP <- c(
      input$SLSRA_CP_1,
      input$SLSRA_CP_2
    )
    names(responses_SLSRA_CP) <- questions_SLSRA_CP   
    
    # SLSRA_NNR responses
    questions_SLSRA_NNR <- c(
      "SLSRA_NNR_1",
      "SLSRA_NNR_2"
    )
    responses_SLSRA_NNR <- c(
      input$SLSRA_NNR_1,
      input$SLSRA_NNR_2
    )
    names(responses_SLSRA_NNR) <- questions_SLSRA_NNR
    
    # SLSRA_NP responses
    questions_SLSRA_NP <- c(
      "SLSRA_NP_1",
      "SLSRA_NP_2"
    )
    responses_SLSRA_NP <- c(
      input$SLSRA_NP_1,
      input$SLSRA_NP_2
    )
    names(responses_SLSRA_NP) <- questions_SLSRA_NP
    
    # SLSRA_NR responses
    questions_SLSRA_NR <- c(
      "SLSRA_NR_1",
      "SLSRA_NR_2"
    )
    responses_SLSRA_NR <- c(
      input$SLSRA_NR_1,
      input$SLSRA_NR_2
    )
    names(responses_SLSRA_NR) <- questions_SLSRA_NR
    
    # SLSRA_RP responses
    questions_SLSRA_RP <- c(
      "SLSRA_RP_1",
      "SLSRA_RP_2"
    )
    responses_SLSRA_RP <- c(
      input$SLSRA_RP_1,
      input$SLSRA_RP_2
    )
    names(responses_SLSRA_RP) <- questions_SLSRA_RP
    
    # SLSRA_RSPB responses
    questions_SLSRA_RSPB <- c(
      "SLSRA_RSPB_1",
      "SLSRA_RSPB_2"
    )
    responses_SLSRA_RSPB <- c(
      input$SLSRA_RSPB_1,
      input$SLSRA_RSPB_2
    )
    names(responses_SLSRA_RSPB) <- questions_SLSRA_RSPB
    
    # SLSRA_SAC responses
    questions_SLSRA_SAC <- c(
      "SLSRA_SAC_1",
      "SLSRA_SAC_2"
    )
    responses_SLSRA_SAC <- c(
      input$SLSRA_SAC_1,
      input$SLSRA_SAC_2
    )
    names(responses_SLSRA_SAC) <- questions_SLSRA_SAC
    
    # SLSRA_SPA responses
    questions_SLSRA_SPA <- c(
      "SLSRA_SPA_1",
      "SLSRA_SPA_2"
    )
    responses_SLSRA_SPA <- c(
      input$SLSRA_SPA_1,
      input$SLSRA_SPA_2
    )
    names(responses_SLSRA_SPA) <- questions_SLSRA_SPA
    
    # SLSRA_SSSI responses
    questions_SLSRA_SSSI <- c(
      "SLSRA_SSSI_1",
      "SLSRA_SSSI_2"
    )
    responses_SLSRA_SSSI <- c(
      input$SLSRA_SSSI_1,
      input$SLSRA_SSSI_2
    )
    names(responses_SLSRA_SSSI) <- questions_SLSRA_SSSI
    
    # SLSRA_SWT responses
    questions_SLSRA_SWT <- c(
      "SLSRA_SWT_1",
      "SLSRA_SWT_2"
    )
    responses_SLSRA_SWT <- c(
      input$SLSRA_SWT_1,
      input$SLSRA_SWT_2
    )
    names(responses_SLSRA_SWT) <- questions_SLSRA_SWT
    
    # SLSRA_WLA responses
    questions_SLSRA_WLA <- c(
      "SLSRA_WLA_1",
      "SLSRA_WLA_2"
    )
    responses_SLSRA_WLA <- c(
      input$SLSRA_WLA_1,
      input$SLSRA_WLA_2
    )
    names(responses_SLSRA_WLA) <- questions_SLSRA_WLA
    
    ###
    # FIPS_N
    # Landform responses
    questions_FIPS_N_Landform <- c(
      "FIPS_N_Landform_1",
      "FIPS_N_Landform_2",
      "FIPS_N_Landform_3",
      "FIPS_N_Landform_4",
      "FIPS_N_Landform_5",
      "FIPS_N_Landform_6",
      "FIPS_N_Landform_7",
      "FIPS_N_Landform_8",
      "FIPS_N_Landform_9",
      "FIPS_N_Landform_10",
      "FIPS_N_Landform_11",
      "FIPS_N_Landform_12",
      "FIPS_N_Landform_13",
      "FIPS_N_Landform_14",
      "FIPS_N_Landform_15",
      "FIPS_N_Landform_16",
      "FIPS_N_Landform_17"
    )
    responses_FIPS_N_Landform <- c(
      input$FIPS_N_Landform_1,
      input$FIPS_N_Landform_2,
      input$FIPS_N_Landform_3,
      input$FIPS_N_Landform_4,
      input$FIPS_N_Landform_5,
      input$FIPS_N_Landform_6,
      input$FIPS_N_Landform_7,
      input$FIPS_N_Landform_8,
      input$FIPS_N_Landform_9,
      input$FIPS_N_Landform_10,
      input$FIPS_N_Landform_11,
      input$FIPS_N_Landform_12,
      input$FIPS_N_Landform_13,
      input$FIPS_N_Landform_14,
      input$FIPS_N_Landform_15,
      input$FIPS_N_Landform_16,
      input$FIPS_N_Landform_17
    )
    names(responses_FIPS_N_Landform) <- questions_FIPS_N_Landform
    
    # FIPS_N_NFI responses
    questions_FIPS_N_NFI <- c(
      "FIPS_N_NFI_1",
      "FIPS_N_NFI_2",
      "FIPS_N_NFI_3",
      "FIPS_N_NFI_4",
      "FIPS_N_NFI_5",
      "FIPS_N_NFI_6",
      "FIPS_N_NFI_7",
      "FIPS_N_NFI_8",
      "FIPS_N_NFI_9",
      "FIPS_N_NFI_10",
      "FIPS_N_NFI_11",
      "FIPS_N_NFI_12",
      "FIPS_N_NFI_13",
      "FIPS_N_NFI_14",
      "FIPS_N_NFI_15",
      "FIPS_N_NFI_16",
      "FIPS_N_NFI_17",
      "FIPS_N_NFI_18",
      "FIPS_N_NFI_19",
      "FIPS_N_NFI_20",
      "FIPS_N_NFI_21",
      "FIPS_N_NFI_22",
      "FIPS_N_NFI_23"
    )
    responses_FIPS_N_NFI <- c(
      input$FIPS_N_NFI_1,
      input$FIPS_N_NFI_2,
      input$FIPS_N_NFI_3,
      input$FIPS_N_NFI_4,
      input$FIPS_N_NFI_5,
      input$FIPS_N_NFI_6,
      input$FIPS_N_NFI_7,
      input$FIPS_N_NFI_8,
      input$FIPS_N_NFI_9,
      input$FIPS_N_NFI_10,
      input$FIPS_N_NFI_11,
      input$FIPS_N_NFI_12,
      input$FIPS_N_NFI_13,
      input$FIPS_N_NFI_14,
      input$FIPS_N_NFI_15,
      input$FIPS_N_NFI_16,
      input$FIPS_N_NFI_17,
      input$FIPS_N_NFI_18,
      input$FIPS_N_NFI_19,
      input$FIPS_N_NFI_20,
      input$FIPS_N_NFI_21,
      input$FIPS_N_NFI_22,
      input$FIPS_N_NFI_23
    )
    names(responses_FIPS_N_NFI) <- questions_FIPS_N_NFI
    
    # FIPS_N_NWSS responses
    questions_FIPS_N_NWSS <- c(
      "FIPS_N_NWSS_1",
      "FIPS_N_NWSS_2",
      "FIPS_N_NWSS_3",
      "FIPS_N_NWSS_4",
      "FIPS_N_NWSS_5",
      "FIPS_N_NWSS_6",
      "FIPS_N_NWSS_7",
      "FIPS_N_NWSS_8",
      "FIPS_N_NWSS_9",
      "FIPS_N_NWSS_10",
      "FIPS_N_NWSS_11",
      "FIPS_N_NWSS_12",
      "FIPS_N_NWSS_13",
      "FIPS_N_NWSS_14",
      "FIPS_N_NWSS_15",
      "FIPS_N_NWSS_16",
      "FIPS_N_NWSS_17",
      "FIPS_N_NWSS_18",
      "FIPS_N_NWSS_19",
      "FIPS_N_NWSS_20",
      "FIPS_N_NWSS_21",
      "FIPS_N_NWSS_22",
      "FIPS_N_NWSS_23",
      "FIPS_N_NWSS_24",
      "FIPS_N_NWSS_25"
    )
    responses_FIPS_N_NWSS <- c(
      input$FIPS_N_NWSS_1,
      input$FIPS_N_NWSS_2,
      input$FIPS_N_NWSS_3,
      input$FIPS_N_NWSS_4,
      input$FIPS_N_NWSS_5,
      input$FIPS_N_NWSS_6,
      input$FIPS_N_NWSS_7,
      input$FIPS_N_NWSS_8,
      input$FIPS_N_NWSS_9,
      input$FIPS_N_NWSS_10,
      input$FIPS_N_NWSS_11,
      input$FIPS_N_NWSS_12,
      input$FIPS_N_NWSS_13,
      input$FIPS_N_NWSS_14,
      input$FIPS_N_NWSS_15,
      input$FIPS_N_NWSS_16,
      input$FIPS_N_NWSS_17,
      input$FIPS_N_NWSS_18,
      input$FIPS_N_NWSS_19,
      input$FIPS_N_NWSS_20,
      input$FIPS_N_NWSS_21,
      input$FIPS_N_NWSS_22,
      input$FIPS_N_NWSS_23,
      input$FIPS_N_NWSS_24,
      input$FIPS_N_NWSS_25
    )
    names(responses_FIPS_N_NWSS) <- questions_FIPS_N_NWSS
    
    # FIPS_N_Soil responses
    questions_FIPS_N_Soil <- c(
      "FIPS_N_Soil_1",
      "FIPS_N_Soil_2",
      "FIPS_N_Soil_3",
      "FIPS_N_Soil_4",
      "FIPS_N_Soil_5",
      "FIPS_N_Soil_6",
      "FIPS_N_Soil_7",
      "FIPS_N_Soil_8",
      "FIPS_N_Soil_9",
      "FIPS_N_Soil_10",
      "FIPS_N_Soil_11",
      "FIPS_N_Soil_12"
    )
    responses_FIPS_N_Soil <- c(
      input$FIPS_N_Soil_1,
      input$FIPS_N_Soil_2,
      input$FIPS_N_Soil_3,
      input$FIPS_N_Soil_4,
      input$FIPS_N_Soil_5,
      input$FIPS_N_Soil_6,
      input$FIPS_N_Soil_7,
      input$FIPS_N_Soil_8,
      input$FIPS_N_Soil_9,
      input$FIPS_N_Soil_10,
      input$FIPS_N_Soil_11,
      input$FIPS_N_Soil_12
    )
    names(responses_FIPS_N_Soil) <- questions_FIPS_N_Soil
    
    # FIPS_N_Slope responses
    questions_FIPS_N_Slope <- c(
      "FIPS_N_Slope_1",
      "FIPS_N_Slope_2",
      "FIPS_N_Slope_3",
      "FIPS_N_Slope_4",
      "FIPS_N_Slope_5",
      "FIPS_N_Slope_6"
    )
    responses_FIPS_N_Slope <- c(
      input$FIPS_N_Slope_1,
      input$FIPS_N_Slope_2,
      input$FIPS_N_Slope_3,
      input$FIPS_N_Slope_4,
      input$FIPS_N_Slope_5,
      input$FIPS_N_Slope_6
    )
    names(responses_FIPS_N_Slope) <- questions_FIPS_N_Slope
    
    ###
    # FIPS_I
    # Road and Track Types responses
    questions_FIPS_I_RoadsTracks <- c(
      "FIPS_I_RoadsTracks_1",
      "FIPS_I_RoadsTracks_2",
      "FIPS_I_RoadsTracks_3",
      "FIPS_I_RoadsTracks_4",
      "FIPS_I_RoadsTracks_5"
    )
    responses_FIPS_I_RoadsTracks <- c(
      input$FIPS_I_RoadsTracks_1,
      input$FIPS_I_RoadsTracks_2,
      input$FIPS_I_RoadsTracks_3,
      input$FIPS_I_RoadsTracks_4,
      input$FIPS_I_RoadsTracks_5
    )
    names(responses_FIPS_I_RoadsTracks) <- questions_FIPS_I_RoadsTracks
    
    # National Cycle Network Surface Types responses
    questions_FIPS_I_NationalCycleNetwork <- c(
      "FIPS_I_NationalCycleNetwork_1",
      "FIPS_I_NationalCycleNetwork_2",
      "FIPS_I_NationalCycleNetwork_3",
      "FIPS_I_NationalCycleNetwork_4"
    )
    responses_FIPS_I_NationalCycleNetwork <- c(
      input$FIPS_I_NationalCycleNetwork_1,
      input$FIPS_I_NationalCycleNetwork_2,
      input$FIPS_I_NationalCycleNetwork_3,
      input$FIPS_I_NationalCycleNetwork_4
    )
    names(responses_FIPS_I_NationalCycleNetwork) <- questions_FIPS_I_NationalCycleNetwork
    
    # NFERR responses
    questions_FIPS_I_NFERR <- c(
      "FIPS_I_NFERR_1",
      "FIPS_I_NFERR_2",
      "FIPS_I_NFERR_3",
      "FIPS_I_NFERR_4",
      "FIPS_I_NFERR_5",
      "FIPS_I_NFERR_6",
      "FIPS_I_NFERR_7",
      "FIPS_I_NFERR_8",
      "FIPS_I_NFERR_9",
      "FIPS_I_NFERR_10"
    )
    responses_FIPS_I_NFERR <- c(
      input$FIPS_I_NFERR_1,
      input$FIPS_I_NFERR_2,
      input$FIPS_I_NFERR_3,
      input$FIPS_I_NFERR_4,
      input$FIPS_I_NFERR_5,
      input$FIPS_I_NFERR_6,
      input$FIPS_I_NFERR_7,
      input$FIPS_I_NFERR_8,
      input$FIPS_I_NFERR_9,
      input$FIPS_I_NFERR_10
    )
    names(responses_FIPS_I_NFERR) <- questions_FIPS_I_NFERR
    
    # NFERA responses
    questions_FIPS_I_NFERA <- c(
      "FIPS_I_NFERA_1",
      "FIPS_I_NFERA_2",
      "FIPS_I_NFERA_3",
      "FIPS_I_NFERA_4",
      "FIPS_I_NFERA_5",
      "FIPS_I_NFERA_6",
      "FIPS_I_NFERA_7",
      "FIPS_I_NFERA_8",
      "FIPS_I_NFERA_9",
      "FIPS_I_NFERA_10",
      "FIPS_I_NFERA_11",
      "FIPS_I_NFERA_12",
      "FIPS_I_NFERA_13",
      "FIPS_I_NFERA_14",
      "FIPS_I_NFERA_15",
      "FIPS_I_NFERA_16",
      "FIPS_I_NFERA_17"
    )
    responses_FIPS_I_NFERA <- c(
      input$FIPS_I_NFERA_1,
      input$FIPS_I_NFERA_2,
      input$FIPS_I_NFERA_3,
      input$FIPS_I_NFERA_4,
      input$FIPS_I_NFERA_5,
      input$FIPS_I_NFERA_6,
      input$FIPS_I_NFERA_7,
      input$FIPS_I_NFERA_8,
      input$FIPS_I_NFERA_9,
      input$FIPS_I_NFERA_10,
      input$FIPS_I_NFERA_11,
      input$FIPS_I_NFERA_12,
      input$FIPS_I_NFERA_13,
      input$FIPS_I_NFERA_14,
      input$FIPS_I_NFERA_15,
      input$FIPS_I_NFERA_16,
      input$FIPS_I_NFERA_17
    )
    names(responses_FIPS_I_NFERA) <- questions_FIPS_I_NFERA
    
    # Local Path Network responses
    questions_FIPS_I_LocalPathNetwork <- c(
      "FIPS_I_LocalPathNetwork_1",
      "FIPS_I_LocalPathNetwork_2"
    )
    responses_FIPS_I_LocalPathNetwork <- c(
      input$FIPS_I_LocalPathNetwork_1,
      input$FIPS_I_LocalPathNetwork_2
    )
    names(responses_FIPS_I_LocalPathNetwork) <- questions_FIPS_I_LocalPathNetwork
    
    #### 
    # Water
    # Water_Rivers responses
    questions_Water_Rivers <- c(
      "Water_Rivers_1",
      "Water_Rivers_2",
      "Water_Rivers_3",
      "Water_Rivers_4",
      "Water_Rivers_5",
      "Water_Rivers_6",
      "Water_Rivers_7"
    )
    responses_Water_Rivers <- c(
      input$Water_Rivers_1,
      input$Water_Rivers_2,
      input$Water_Rivers_3,
      input$Water_Rivers_4,
      input$Water_Rivers_5,
      input$Water_Rivers_6,
      input$Water_Rivers_7
    )
    names(responses_Water_Rivers) <- questions_Water_Rivers
    
    # Water_Lakes responses
    questions_Water_Lakes <- c(
      "Water_Lakes_1",
      "Water_Lakes_2",
      "Water_Lakes_3",
      "Water_Lakes_4",
      "Water_Lakes_5",
      "Water_Lakes_6"
    )
    responses_Water_Lakes <- c(
      input$Water_Lakes_1,
      input$Water_Lakes_2,
      input$Water_Lakes_3,
      input$Water_Lakes_4,
      input$Water_Lakes_5,
      input$Water_Lakes_6
    )
    names(responses_Water_Lakes) <- questions_Water_Lakes
    
    ###
    
    # Update CSV files
    update_csv(file_path_FIPS_I_RoadsTracks, questions_FIPS_I_RoadsTracks, responses_FIPS_I_RoadsTracks, input$persona_id)
    update_csv(file_path_FIPS_I_NationalCycleNetwork, questions_FIPS_I_NationalCycleNetwork, responses_FIPS_I_NationalCycleNetwork, input$persona_id)
    update_csv(file_path_FIPS_I_NFERR, questions_FIPS_I_NFERR, responses_FIPS_I_NFERR, input$persona_id)
    update_csv(file_path_FIPS_I_NFERA, questions_FIPS_I_NFERA, responses_FIPS_I_NFERA, input$persona_id)
    update_csv(file_path_FIPS_I_LocalPathNetwork, questions_FIPS_I_LocalPathNetwork, responses_FIPS_I_LocalPathNetwork, input$persona_id)
    
    update_csv(file_path_FIPS_N_Landform, questions_FIPS_N_Landform, responses_FIPS_N_Landform, input$persona_id)
    update_csv(file_path_FIPS_N_NFI, questions_FIPS_N_NFI, responses_FIPS_N_NFI, input$persona_id)
    update_csv(file_path_FIPS_N_NWSS, questions_FIPS_N_NWSS, responses_FIPS_N_NWSS, input$persona_id)
    update_csv(file_path_FIPS_N_Soil, questions_FIPS_N_Soil, responses_FIPS_N_Soil, input$persona_id)
    update_csv(file_path_FIPS_N_Slope, questions_FIPS_N_Slope, responses_FIPS_N_Slope, input$persona_id)
    
    update_csv(file_path_Water_Lakes, questions_Water_Lakes, responses_Water_Lakes, input$persona_id)
    update_csv(file_path_Water_Rivers, questions_Water_Rivers, responses_Water_Rivers, input$persona_id)
    
    update_csv(file_path_SLSRA_CP, questions_SLSRA_CP, responses_SLSRA_CP, input$persona_id)
    update_csv(file_path_SLSRA_HLUA, questions_SLSRA_HLUA, responses_SLSRA_HLUA, input$persona_id)
    update_csv(file_path_SLSRA_HNV, questions_SLSRA_HNV, responses_SLSRA_HNV, input$persona_id)
    update_csv(file_path_SLSRA_LCM, questions_SLSRA_LCM, responses_SLSRA_LCM, input$persona_id)
    update_csv(file_path_SLSRA_NNR, questions_SLSRA_NNR, responses_SLSRA_NNR, input$persona_id)
    update_csv(file_path_SLSRA_NP, questions_SLSRA_NP, responses_SLSRA_NP, input$persona_id)
    update_csv(file_path_SLSRA_NR, questions_SLSRA_NR, responses_SLSRA_NR, input$persona_id)
    update_csv(file_path_SLSRA_RP, questions_SLSRA_RP, responses_SLSRA_RP, input$persona_id)
    update_csv(file_path_SLSRA_RSPB, questions_SLSRA_RSPB, responses_SLSRA_RSPB, input$persona_id)
    update_csv(file_path_SLSRA_SAC, questions_SLSRA_SAC, responses_SLSRA_SAC, input$persona_id)
    update_csv(file_path_SLSRA_SPA, questions_SLSRA_SPA, responses_SLSRA_SPA, input$persona_id)
    update_csv(file_path_SLSRA_SSSI, questions_SLSRA_SSSI, responses_SLSRA_SSSI, input$persona_id)
    update_csv(file_path_SLSRA_SWT, questions_SLSRA_SWT, responses_SLSRA_SWT, input$persona_id)
    update_csv(file_path_SLSRA_WLA, questions_SLSRA_WLA, responses_SLSRA_WLA, input$persona_id)
    
    output$response <- renderText("Thank you for your responses! They have been recorded.")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
