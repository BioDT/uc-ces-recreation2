library(shiny)
library(shinyjs)
library(leaflet)
library(sf)

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
  ui_page1(),
  ui_page1b(),
  ui_page2(),
  ui_page3(),
  ui_page4(),
  ui_page5(),
  ui_page6()
)


# Define main server logic
server <- function(input, output, session) {
  # Call server logic for each page
  shapefile_name_global <- reactiveValues(input_text = NULL)
  persona_id_global <- reactiveValues(input_text = NULL)
  #persona_scores_global <- reactiveValues(scores = NULL)
  
  server_page1(input, output, session, shapefile_name_global)
  server_page1b(input, output, session, persona_id_global) #, persona_scores_global
  server_page2(input, output, session) #, persona_id_global, persona_scores_global
  server_page3(input, output, session) #, persona_scores_global
  server_page4(input, output, session) #, persona_scores_global
  server_page5(input, output, session) #, persona_scores_global
  server_page6(input, output, session, shapefile_name_global, persona_id_global)
  
  # Navigation logic
  observeEvent(input$next1, {
    hide("page1")
    show("page1b")
  })
  
  
  observeEvent(input$back6, {
    hide("page1b")
    show("page1")
  })
  
  observeEvent(input$next6, {
    hide("page1b")
    show("page2")
  })
  
  
  
  observeEvent(input$back1, {
    hide("page2")
    show("page1b")
  })
  
  observeEvent(input$next2, {
    hide("page2")
    show("page3")
  })
  
  observeEvent(input$back2, {
    hide("page3")
    show("page2")
  })
  
  observeEvent(input$next3, {
    hide("page3")
    show("page4")
  })
  
  observeEvent(input$back3, {
    hide("page4")
    show("page3")
  })
  
  observeEvent(input$next4, {
    hide("page4")
    show("page5")
  })
  
  observeEvent(input$back4, {
    hide("page5")
    show("page4")
  })
  
  observeEvent(input$next5, {
    hide("page5")
    show("page6")
  })
  
  observeEvent(input$back5, {
    hide("page6")
    show("page5")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
