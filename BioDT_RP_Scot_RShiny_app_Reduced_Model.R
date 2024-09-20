# This is the overall RShiny script for the BioDT Recreational Potential Model
# The model consists for 4 components (SLSRA, FIPS_N, FIPS_I and Water)
# The model essentially reclassifies raster values with user scores, sums and normalises the output
# For FIPS_I and Water components distance from feature is also used in the calculation
# As it consists of several pages, each page has a sever and UI script saved as functions to be called by this script


# Clear r memory between sessions
rm(list = ls())


# Function to check, install, and load packages
check_install_load <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
  library(pkg, character.only = TRUE)
}

# List of packages to check, install, and load
packages_to_load <- c("tidyverse", "leaflet", "sf", "jsonlite", "shinyjs", "shiny", "raster") #"foreach", "doParallel", 

# Loop through each package
for (pkg in packages_to_load) {
  check_install_load(pkg)
}

### paths - edit this if parent folder structure changes!! ###
home_folder <- "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/"

# Source code for RShiny UI side
source(paste0(home_folder, "RShiny_Functions/UI_Functions/FUNC_UI_Page1.R")) # UI Page for: Selecting / uploading a shapefile
source(paste0(home_folder, "RShiny_Functions/UI_Functions/FUNC_UI_Page1b.R")) # UI Page for: Selecting / creating a Persona
source(paste0(home_folder, "RShiny_Functions/UI_Functions/FUNC_UI_Page2.R")) # UI Page for: Parameterizing model component (SLSRA)
source(paste0(home_folder, "RShiny_Functions/UI_Functions/FUNC_UI_Page3.R")) # UI Page for: Parameterizing model component (FIPS_N)
source(paste0(home_folder, "RShiny_Functions/UI_Functions/FUNC_UI_Page4.R")) # UI Page for: Parameterizing model component (FIPS_I)
source(paste0(home_folder, "RShiny_Functions/UI_Functions/FUNC_UI_Page5.R")) # UI Page for: Parameterizing model component (Water), including submitting and exporting values
source(paste0(home_folder, "RShiny_Functions/UI_Functions/FUNC_UI_Page6.R")) # UI Page for: Running and visualizing model, including exporting output


# Source code for RShiny server side
source(paste0(home_folder, "RShiny_Functions/Server_Functions/FUNC_Server_Page1.R")) # Server page for: Selecting / uploading a shapefile
source(paste0(home_folder, "RShiny_Functions/Server_Functions/FUNC_Server_Page1b.R")) # Server page for: Selecting / creating a Persona
source(paste0(home_folder, "RShiny_Functions/Server_Functions/FUNC_Server_Page2.R")) # Server page for: Parameterizing model component (SLSRA)
source(paste0(home_folder, "RShiny_Functions/Server_Functions/FUNC_Server_Page3.R")) # Server page for: Parameterizing model component (FIPS_N)
source(paste0(home_folder, "RShiny_Functions/Server_Functions/FUNC_Server_Page4.R")) # Server page for: Parameterizing model component (FIPS_I)
source(paste0(home_folder, "RShiny_Functions/Server_Functions/FUNC_Server_Page5.R")) # Server page for: Parameterizing model component (Water), including submitting and exporting values
source(paste0(home_folder, "RShiny_Functions/Server_Functions/FUNC_Server_Page6.R")) # Server page for: Running and visualizing model, including exporting output


# Combine all UI components
ui <- fluidPage(
  titlePanel("BioDT - Scotland Recreational Model"),
  useShinyjs(),  # Initialize shinyjs
  tabsetPanel(id = "nav_panel",
              tabPanel("Area of Interest", ui_page1()),
              tabPanel("Select Persona", ui_page1b()),
              tabPanel("SLSRA", ui_page2()),
              tabPanel("FIPS_N", ui_page3()),
              tabPanel("FIPS_I", ui_page4()),
              tabPanel("Water", ui_page5()),
              tabPanel("Model Run", ui_page6())
  )
)

# Define main server logic
server <- function(input, output, session) {
  # Call server logic for each page
  shapefile_name_global <- reactiveValues(input_text = NULL)
  persona_id_global <- reactiveValues(input_text = NULL)
  skip_to_page6 <- reactiveValues(skip = FALSE)
  
  # Initialize reactive values for storing form data
  all_form_data <- reactiveValues(data = data.frame(Name = character(), Response = character(), stringsAsFactors = FALSE))
  
  # Define the CSV file path to the master dataset containing raster values for reclassifying
  csv_path <- paste0(home_folder, "input/MASTER_BIODT_RP_SCOT_SCORES_ALL.csv")
  
  # Load the existing CSV into form_data at the start
  form_data <- reactiveVal(read.csv(csv_path, stringsAsFactors = FALSE))
  
  # setting the page environments
  server_page1(input, output, session, shapefile_name_global, home_folder)
  server_page1b(input, output, session, persona_id_global, skip_to_page6, home_folder)
  server_page2(input, output, session, all_form_data)
  server_page3(input, output, session, all_form_data)
  server_page4(input, output, session, all_form_data)
  server_page5(input, output, session, all_form_data, form_data, csv_path, home_folder)
  server_page6(input, output, session, shapefile_name_global, persona_id_global, home_folder)
  
  # Navigation logic
  observeEvent(input$next1, {
    updateTabsetPanel(session, "nav_panel", selected = "Select Persona")
  })
  
  observeEvent(input$back6, {
    updateTabsetPanel(session, "nav_panel", selected = "Area of Interest")
  })
  
  observeEvent(input$next6, {
    if (skip_to_page6$skip) {
      updateTabsetPanel(session, "nav_panel", selected = "Model Run")
    } else {
      updateTabsetPanel(session, "nav_panel", selected = "SLSRA")
    }
  })
  
  observeEvent(input$back1, {
    updateTabsetPanel(session, "nav_panel", selected = "Select Persona")
  })
  
  observeEvent(input$next2, {
    updateTabsetPanel(session, "nav_panel", selected = "FIPS_N")
  })
  
  observeEvent(input$back2, {
    updateTabsetPanel(session, "nav_panel", selected = "SLSRA")
  })
  
  observeEvent(input$next3, {
    updateTabsetPanel(session, "nav_panel", selected = "FIPS_I")
  })
  
  observeEvent(input$back3, {
    updateTabsetPanel(session, "nav_panel", selected = "FIPS_N")
  })
  
  observeEvent(input$next4, {
    updateTabsetPanel(session, "nav_panel", selected = "Water")
  })
  
  observeEvent(input$back4, {
    updateTabsetPanel(session, "nav_panel", selected = "FIPS_I")
  })
  
  observeEvent(input$next5, {
    updateTabsetPanel(session, "nav_panel", selected = "Model Run")
  })
  
  observeEvent(input$back5, {
    updateTabsetPanel(session, "nav_panel", selected = "Water")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

