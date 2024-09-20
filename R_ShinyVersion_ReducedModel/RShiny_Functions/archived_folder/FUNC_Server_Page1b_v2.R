server_page1b <- function(input, output, session, persona_id_global, skip_to_page6) {
  library(shiny)
  library(shinyjs)
  
  # directory to store personas (the complete file)
  persona_dir <- "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/output/Persona_Scores/"
  
  # function to list personas which already exist
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
  
  observe({
    persona_files <- list_persona_files(persona_dir)
    if (!is.null(persona_files)) {
      updateSelectInput(session, "edit_persona_file", choices = persona_files)
    }
  })
  
  observeEvent(input$submit_persona_id, {
    req(input$persona_id)
    
    if (input$persona_id == "") {
      output$response_sidebar <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # create a local variable for personas
    persona_id <- input$persona_id
    
    # create a global variable for persona
    persona_id_global$input_text <- persona_id
    
    # check if persona already exists
    file_to_check <- paste0(persona_dir, persona_id, ".csv")
    
    if (file.exists(file_to_check)) {
      output$response_sidebar <- renderText("This ID already exists. Please choose another.")
    } else {
      output$response_sidebar <- renderText("Persona ID is valid and available.")
      skip_to_page6$skip <- FALSE  # New persona, go through all pages
    }
    
    print(paste("Incoming global Persona ID (created): ", persona_id_global$input_text))
  })
  
  
  # # section allows for pre-populating existing persona form
  # observeEvent(input$load_existing_persona, {
  #   req(input$existing_persona_file)
  #   
  #   persona_file_path <- input$existing_persona_file
  #   persona_id <- tools::file_path_sans_ext(basename(persona_file_path))
  #   persona_id_global$input_text <- persona_id
  #   
  #   output$response_sidebar <- renderText(paste("Loaded existing persona:", persona_id))
  #   
  #   # Read the persona CSV file
  #   persona_data <- read.csv(persona_file_path, stringsAsFactors = FALSE)
  #   
  #   # Extract the question-response pairs from the CSV
  #   question_responses <- setNames(persona_data[, persona_id], persona_data$Name)
  #   
  #   # Update the UI inputs with the saved values
  #   lapply(names(question_responses), function(q) {
  #     updateNumericInput(session, q, value = question_responses[[q]])
  #   })
  #   
  #   skip_to_page6$skip <- TRUE  # Existing persona, skip to page 6
  #   
  #   print(paste("Incoming global Persona ID (existing): ", persona_id_global$input_text))
  # })
  
  
  
  # Handle the different cases of file options
  observeEvent(input$file_option, {
    shinyjs::hide("persona_id")
    shinyjs::hide("submit_persona_id")
    shinyjs::hide("existing_persona_file")
    shinyjs::hide("load_existing_persona")
    shinyjs::hide("edit_persona_file")
    shinyjs::hide("new_persona_id")
    shinyjs::hide("edit_persona")
    
    if (input$file_option == "create_new") {
      shinyjs::show("persona_id")
      shinyjs::show("submit_persona_id")
    } else if (input$file_option == "load_existing") {
      shinyjs::show("existing_persona_file")
      shinyjs::show("load_existing_persona")
    } else if (input$file_option == "edit_existing") {
      shinyjs::show("edit_persona_file")
      shinyjs::show("new_persona_id")
      shinyjs::show("edit_persona")
    }
  })
  
  # Handle existing persona loading
  observeEvent(input$load_existing_persona, {
    req(input$existing_persona_file)
    
    persona_file_path <- input$existing_persona_file
    persona_id <- tools::file_path_sans_ext(basename(persona_file_path))
    persona_id_global$input_text <- persona_id
    
    output$response_sidebar <- renderText(paste("Loaded existing persona:", persona_id))
    
    # Read the persona CSV file
    persona_data <- read.csv(persona_file_path, stringsAsFactors = FALSE)
    
    # Extract the question-response pairs from the CSV
    question_responses <- setNames(persona_data[, persona_id], persona_data$Name)
    
    # Update the UI inputs with the saved values
    lapply(names(question_responses), function(q) {
      updateNumericInput(session, q, value = question_responses[[q]])
    })
    
    skip_to_page6$skip <- TRUE  # Jump to Page 6 for existing persona
  })
  
  # Handle editing existing persona
  observeEvent(input$edit_persona, {
    req(input$edit_persona_file)
    
    persona_file_path <- input$edit_persona_file
    persona_id <- tools::file_path_sans_ext(basename(persona_file_path))
    persona_id_global$input_text <- persona_id
    
    output$response_sidebar <- renderText(paste("Editing existing persona:", persona_id))
    
    # Read the persona CSV file
    persona_data <- read.csv(persona_file_path, stringsAsFactors = FALSE)
    
    # Extract the question-response pairs from the CSV
    question_responses <- setNames(persona_data[, persona_id], persona_data$Name)
    
    # Update the UI inputs with the saved values
    lapply(names(question_responses), function(q) {
      updateNumericInput(session, q, value = question_responses[[q]])
    })
    
    # Optional: Allow renaming of the persona
    new_persona_id <- input$new_persona_id
    if (new_persona_id != "") {
      persona_id_global$input_text <- new_persona_id
    }
    
    output$response_sidebar <- renderText(paste("Editing persona:", persona_id_global$input_text))
    skip_to_page6$skip <- FALSE  # Don't skip to page 6
  })
  
  # # Function to populate input fields for editing
  # update_question_inputs <- function(session, loaded_persona_data) {
  #   lapply(loaded_persona_data$Name, function(question_id) {
  #     updateNumericInput(session, question_id, value = loaded_persona_data$Response[loaded_persona_data$Name == question_id])
  #   })
  # }
  
  
}