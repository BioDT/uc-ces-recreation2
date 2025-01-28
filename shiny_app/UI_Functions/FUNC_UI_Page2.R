# Define UI for Page 2
ui_page2 <- function() {
#  hidden(
  div(
    id = "page2",
    h2("Step 3: Persona Parameterization"),
    sidebarLayout(
      sidebarPanel(
        
        actionButton("back1", "Back"),
        actionButton("next2", "Next"),
        
        tags$hr(style="border-color: black; border-width: 3px;"), # horizontal line
        #textInput("persona_id", "Please enter a suitable ID for your RP Persona:", value = ""),
        #tags$script("document.getElementById('persona_id').addEventListener('input', function(event) { this.value = this.value.toUpperCase(); });"),
        
        h3(tags$b("SLSRA: The Suitability of land to support RP")),
        
        br(),  # This adds a blank line
        
        h4("This section is about the suitability of land to support RP based on its natural features (its degree of naturalness).  
         Whilst considering this from the view point of your Persona, please score each with a value between 0 and 10"),
        
        ### SLSRA
        
        br(),  # This adds a blank line
        
        h3("Land Cover Types"),
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
        
        hr(),  # This adds a feint horizontal line
        br(),  # This adds a blank line
        
        h3("Areas designated as of High Nature Value farming (HNV)"),
        numericInput("SLSRA_HNV_2", "Farmland IS designated as HNV", value = 0, min = 0, max = 10),
        
        br(),  # This adds a blank line
        tags$hr(style="border-color: black; border-width: 3px;"),  # This adds a horizontal line
        br(),  # This adds a blank line
        
        h4(tags$b("The remaining SLSRA inputs are various land designations or different types of publicly accessible 
         reserves.  Please consider how relevant each is to your Persona, and score with a value between 0 and 10")),
        
        br(),  # This adds a blank line
        
        h3(tags$b("Landscape designations primarily for protection of species/landscape")),
        
        br(),  # This adds a blank line
        
        h3("Areas designated as a Special Area of Conservation (SAC)"),
        numericInput("SLSRA_SAC_2", "Land IS designated as a Special Area of Conservation (SAC)", value = 0, min = 0, max = 10),
        
        h3("Areas designated as a Special Protection Area (SPA)"),
        numericInput("SLSRA_SPA_2", "Land IS designated as a Special Protection Area (SPA)", value = 0, min = 0, max = 10),
        
        h3("Areas designated as a Site of Special Scientific Interest (SSSI)"),
        numericInput("SLSRA_SSSI_2", "Land IS designated as a Site of Special Scientific Interest (SSSI)", value = 0, min = 0, max = 10),
        
        h3("Areas designated as a Wild Land Area"),
        numericInput("SLSRA_WLA_2", "Land IS designated as a Wild Land Area", value = 0, min = 0, max = 10),
        
        hr(),  # This adds a feint horizontal line
        br(),  # This adds a blank line
        h3(tags$b("Landscape designations focused on people and landscape")),
        br(),  # This adds a blank line
        
        h3("Areas designated as a Country Park"),
        numericInput("SLSRA_CP_2", "Land IS designated as a Country Park", value = 0, min = 0, max = 10),
        
        h3("Areas designated as a National Nature Reserve (NNR)"),
        numericInput("SLSRA_NNR_2", "Land IS designated as a National Nature Reserve", value = 0, min = 0, max = 10),
        
        h3("Areas designated as a National Park"),
        numericInput("SLSRA_NP_2", "Land IS designated as a National Park", value = 0, min = 0, max = 10),
        
        h3("Areas designated as a Nature Reserve"),
        numericInput("SLSRA_NR_2", "Land IS designated as a Nature Reserve", value = 0, min = 0, max = 10),
        
        h3("Areas designated as a Regional Park"),
        numericInput("SLSRA_RP_2", "Land IS designated as a Regional Park", value = 0, min = 0, max = 10),
        
        hr(),  # This adds a feint horizontal line
        br(),  # This adds a blank line
        h3(tags$b("Charity owned reserves as places to visit nature and landscapes")),
        br(),  # This adds a blank line
        
        h3("Areas designated as a RSPB Reserve"),
        numericInput("SLSRA_RSPB_2", "Land IS designated as a RSPB Reserve", value = 0, min = 0, max = 10),
        
        h3("Areas designated as a Scottish Wildlife Trust Reserve"),
        numericInput("SLSRA_SWT_2", "Land IS designated as a Scottish Wildlife Trust Reserve", value = 0, min = 0, max = 10),
        
        tags$hr(style="border-color: black; border-width: 3px;"), # horizontal line
        
        actionButton("back1", "Back"),
        actionButton("next2", "Next"),
        width = 6
      ),
      
      mainPanel()
    )
#  )
  )
}
