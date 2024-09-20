server_page1b <- function(input, output, session, persona_id_global) {
  library(shiny)
  library(shinyjs)
  
  persona_dir <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/output/Persona_Scores/"
  
  list_persona_files <- function(dir) {
    persona_paths <- list.files(dir, pattern = "\\.csv$", full.names = TRUE)
    if (length(persona_paths) == 0) {
      return(NULL)
    }
    persona_names <- basename(persona_paths)
    persona_names <- tools::file_path_sans_ext(persona_names)
    names(persona_paths) <- persona_names
    persona_paths
  }
  
  observe({
    persona_files <- list_persona_files(persona_dir)
    if (!is.null(persona_files)) {
      updateSelectInput(session, "existing_persona_file", choices = persona_files)
    }
  })
  
  observeEvent(input$submit_persona_id, {
    req(input$persona_id)
    
    if (input$persona_id == "") {
      output$response_sidebar <- renderText("Please enter a Persona ID.")
      return()
    }
    
    persona_id <- input$persona_id
    persona_id_global$input_text <- persona_id
    file_to_check <- paste0(persona_dir, persona_id, ".csv")
    
    if (file.exists(file_to_check)) {
      output$response_sidebar <- renderText("This ID already exists. Please choose another.")
    } else {
      output$response_sidebar <- renderText("Persona ID is valid and available.")
    }
    
    print(paste("Incoming global Persona ID (created): ", persona_id_global$input_text))
  })
  
  observeEvent(input$load_existing_persona, {
    req(input$existing_persona_file)
    
    persona_file_path <- input$existing_persona_file
    persona_id <- tools::file_path_sans_ext(basename(persona_file_path))
    persona_id_global$input_text <- persona_id
    
    output$response_sidebar <- renderText(paste("Loaded existing persona:", persona_id))
    
    #persona_data <- read.csv(persona_file_path, stringsAsFactors = FALSE)
    #persona_scores_global$scores <- persona_data
    
    print(paste("Incoming global Persona ID (existing): ", persona_id_global$input_text))
  })
  
  observeEvent(input$file_option, {
    shinyjs::hide("persona_id")
    shinyjs::hide("submit_persona_id")
    shinyjs::hide("existing_persona_file")
    shinyjs::hide("load_existing_persona")
    
    if (input$file_option == "create_new") {
      shinyjs::show("persona_id")
      shinyjs::show("submit_persona_id")
    } else if (input$file_option == "load_existing") {
      shinyjs::show("existing_persona_file")
      shinyjs::show("load_existing_persona")
    }
  })
}
