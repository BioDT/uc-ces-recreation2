# =============================================================
# Project Name: BIODT
# Last Updated: 2024-11-22
#
# Description of this version:
# Modification to the folder structure and scripts to reduce run-time. Added input files with Rastspats with multiple layers,
# already standardized.
# =============================================================

library(here)
library(tidyverse)
library(leaflet)
library(sf)
library(jsonlite)
library(shinyjs)
library(shiny)
library(terra)
library(units)
#library(parallel)

rm(list = ls())

#set directory

setwd(here::here())

# Function to check, install, and load packages
#check_install_load <- function(pkg) {
#  if (!requireNamespace(pkg, quietly = TRUE)) {
#    install.packages(pkg, dependencies = TRUE)
#  }
#  library(pkg, character.only = TRUE)
#}

# List of packages to check, install, and load
#packages_to_load <- c("tidyverse", "leaflet", "sf", "jsonlite", "shinyjs", "shiny", "terra", "units", "parallel")

# Loop through each package
#for (pkg in packages_to_load) {
#  check_install_load(pkg)
#}


#Load the paths and functions
home_folder             <- paste0(getwd(), "/")
folder_ui_functions     <- "Functions/RShiny_Functions/UI_Functions/"
folder_server_functions <- "Functions/RShiny_Functions/Server_Functions/"
folder_utils_functions  <- "Functions/RFunctions/"

# Source code for UI side
source(paste0(home_folder, folder_ui_functions, "FUNC_UI_Page1.R")) # UI Page for: Selecting / uploading a shapefile
source(paste0(home_folder, folder_ui_functions, "FUNC_UI_Page1b.R")) # UI Page for: Selecting / creating a Persona
source(paste0(home_folder, folder_ui_functions, "FUNC_UI_Page2.R")) # UI Page for: Parameterizing model component (SLSRA)
source(paste0(home_folder, folder_ui_functions, "FUNC_UI_Page3.R")) # UI Page for: Parameterizing model component (FIPS_N)
source(paste0(home_folder, folder_ui_functions, "FUNC_UI_Page4.R")) # UI Page for: Parameterizing model component (FIPS_I)
source(paste0(home_folder, folder_ui_functions, "FUNC_UI_Page5.R")) # UI Page for: Parameterizing model component (Water), including submitting and exporting values
source(paste0(home_folder, folder_ui_functions, "FUNC_UI_Page6.R")) # UI Page for: Running and visualizing model, including exporting output

# Source code for server side
source(paste0(home_folder, folder_server_functions, "FUNC_Server_Page1.R")) # Server page for: Selecting / uploading a shapefile
source(paste0(home_folder, folder_server_functions, "FUNC_Server_Page1b.R")) # Server page for: Selecting / creating a Persona
source(paste0(home_folder, folder_server_functions, "FUNC_Server_Page2.R")) # Server page for: Parameterizing model component (SLSRA)
source(paste0(home_folder, folder_server_functions, "FUNC_Server_Page3.R")) # Server page for: Parameterizing model component (FIPS_N)
source(paste0(home_folder, folder_server_functions, "FUNC_Server_Page4.R")) # Server page for: Parameterizing model component (FIPS_I)
source(paste0(home_folder, folder_server_functions, "FUNC_Server_Page5.R")) # Server page for: Parameterizing model component (Water), including submitting and exporting values
source(paste0(home_folder, folder_server_functions, "FUNC_Server_Page6.R")) # Server page for: Running and visualizing model, including exporting output

#source functions
source(paste0(home_folder, folder_utils_functions, "FUNC_Raster_Reclassifier_single_csv.R")) #FUNC_Raster_Reclassifier_single_csv.R
source(paste0(home_folder, folder_utils_functions, "FUNC_Process_Raster_Proximity2.R"))
source(paste0(home_folder, folder_utils_functions, "FUNC_Calculate_Euclidean_Distance.R"))
source(paste0(home_folder, folder_utils_functions, "FUNC_Normalise_Rasters.R"))
source(paste0(home_folder, folder_utils_functions, "FUNC_Crop_Rasters_by_mask.R"))
source(paste0(home_folder, folder_utils_functions, "FUNC_Skip_Prox_on_Rasters_Without_NA.R"))
source(paste0(home_folder, folder_utils_functions, "FUNC_Process_Area_of_Interest.R"))
source(paste0(home_folder, folder_utils_functions, "FUNC_other_functions.R"))

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
  
  # Initialize reactive values for storing form data
  shapefile_name_global <- reactiveValues(input_text = NULL)
  persona_id_global     <- reactiveValues(input_text = NULL)
  skip_to_page6         <- reactiveValues(skip = FALSE)
  all_form_data <- reactiveValues(data = data.frame(Name = character(),
                                                    Response = character(),
                                                    stringsAsFactors = FALSE)
                                  )
  # Define the CSV file path to the master dataset containing raster values for reclassifying
  csv_path <- paste0(home_folder, "Data/input/BIODT_RP_SCOT_SCORES_ALL.csv")
  
  # Load the existing CSV into form_data at the start
  form_data <- reactiveVal(read.csv(csv_path, stringsAsFactors = FALSE))
  
  #direct to input/output folder
  input_folder <- paste0(home_folder, "Data/input/")
  output_folder <- paste0(home_folder, "Data/output/")
  
  #define the directory to contain raw shapefiles
  upload_dir <- paste0(home_folder, "Data/input/Raw_Shapefile/")
  
  #define the directory that contains the personas files
  persona_dir <- paste0(home_folder, "Data/input/Persona_Loaded/")
  
  #define the directory that will contain the boundaries files
  boundary_dir <- paste0(home_folder, "Data/input/Boundary_Data/")
  
  #define the directory that has the raster files files
  raster_folder <- paste0(input_folder, "Processed_Data/")
  
  #path to temp folder
  temp_folder <- paste0(output_folder, "temp_folder/")
  
  # Call server logic for each page
  server_page1(input, output, session, shapefile_name_global, home_folder, upload_dir)
  server_page1b(input, output, session, persona_id_global, skip_to_page6, home_folder, persona_dir)
  server_page2(input, output, session, all_form_data)
  server_page3(input, output, session, all_form_data)
  server_page4(input, output, session, all_form_data)
  server_page5(input, output, session, all_form_data, form_data, csv_path, home_folder)
  server_page6(input, output, session, shapefile_name_global, persona_id_global, home_folder,
               input_folder, output_folder, persona_dir, upload_dir, boundary_dir, raster_folder, temp_folder
               )
  
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