library(shiny)
library(shinyjs)
library(leaflet)
library(sf)
library(jsonlite)

# Source code for UI side
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/UI_Functions/FUNC_UI_Page1.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/UI_Functions/FUNC_UI_Page2.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/UI_Functions/FUNC_UI_Page3.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/UI_Functions/FUNC_UI_Page4.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/UI_Functions/FUNC_UI_Page5.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/UI_Functions/FUNC_UI_Page6.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/UI_Functions/FUNC_UI_Page1b.R")

# Source code for server side
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/Server_Functions/FUNC_Server_Page1.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/Server_Functions/FUNC_Server_Page2.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/Server_Functions/FUNC_Server_Page3.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/Server_Functions/FUNC_Server_Page4.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/Server_Functions/FUNC_Server_Page5.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/Server_Functions/FUNC_Server_Page6.R")
source("/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/Functions/Server_Functions/FUNC_Server_Page1b.R")

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
  
  server_page1(input, output, session, shapefile_name_global)
  server_page1b(input, output, session, persona_id_global, skip_to_page6)
  server_page2(input, output, session) #, persona_id_global
  server_page3(input, output, session)
  server_page4(input, output, session)
  server_page5(input, output, session)
  server_page6(input, output, session, shapefile_name_global, persona_id_global)
  
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