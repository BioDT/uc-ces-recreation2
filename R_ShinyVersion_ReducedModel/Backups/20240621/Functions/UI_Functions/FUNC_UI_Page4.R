# Define UI for Page 4
ui_page4 <- function() {
  hidden(
  div(
    id = "page4",
    h2("Step 2: Model Parameterization"),
    sidebarLayout(
      sidebarPanel(
        
        actionButton("back3", "Back"),
        actionButton("next4", "Next"),
        
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
      
        actionButton("back3", "Back"),
        actionButton("next4", "Next")
      ),
      
      mainPanel()
    )
  )
  )
}