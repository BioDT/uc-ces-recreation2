# Define server logic for Page 5
server_page5 <- function(input, output, session) {
  
  combine_files <- function(file_paths, persona_id) {
    all_data <- lapply(file_paths, function(file_path) {
      if (file.exists(file_path)) {
        data <- read.csv(file_path, stringsAsFactors = FALSE, check.names = FALSE)
        if (!("Name" %in% colnames(data))) {
          stop(paste("The file", file_path, "does not have a 'Name' column."))
        }
        if (!(persona_id %in% colnames(data))) {
          stop(paste("The file", file_path, "does not have a '", persona_id, "' column.", sep = ""))
        }
        # Keep only 'Name', 'Description' columns, and the 'persona_id' column
        selected_columns <- c("Name", "Description", "Raster_Val", persona_id) # added raster_val back in
        data <- data[, selected_columns, drop = FALSE]
        # Rename persona_id column to 'Score'
        # colnames(data)[colnames(data) == persona_id] <- "Score" # removed renaming to keep it as persona name
        return(data)
      } else {
        stop(paste("The file", file_path, "does not exist."))
      }
    })
    
    combined_data <- do.call(rbind, all_data)
    return(combined_data)
  }
  
  
  # Paths to search for CSV files
  folders <- c(
    "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/FIPS_I",
    "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/FIPS_N",
    "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA",
    "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/Water"
  )
  
  
  # Find all CSV files in the specified folders recursively
  file_paths <- reactive({
    unlist(lapply(folders, function(folder) {
      list.files(folder, pattern = "\\.csv$", full.names = TRUE, recursive = TRUE)
    }))
  })
  
  combined_data <- reactiveVal(NULL)
  
  
 ###################
  
   # Define file paths in a list
  file_paths2 <- list(
    Water_Lakes = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/Water/Water_Lakes.csv",
    Water_Rivers = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/Water/Water_Rivers.csv"
  )
  
  
  # Function to update a CSV file
  update_csv <- function(file_path, questions, responses, persona_id) {
    if (!file.exists(file_path)) {
      stop(paste("The file", file_path, "does not exist."))
    }
    data <- read.csv(file_path, stringsAsFactors = FALSE, check.names = FALSE)
    
    data[[persona_id]] <- NA  # Initialize new column with NA
    for (question in names(responses)) {
      row_index <- which(data[, 1] == question)
      if (length(row_index) > 0) {
        data[row_index, persona_id] <- responses[question]
      }
    }
    
    write.csv(data, file_path, row.names = FALSE, na = "")
  }
  
  # Define questions and responses in a list of lists
  water_questions <- list(
    Water_Lakes = paste0("Water_Lakes_", 1:6),
    Water_Rivers = paste0("Water_Rivers_", 1:7)
  )
  
  
  # Event handler for submit button
  observeEvent(input$submit, {
    # Ensure Persona ID is provided
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Loop through each file and update
    for (key in names(file_paths2)) {
      file_path <- file_paths2[[key]]
      questions <- water_questions[[key]]
      responses <- sapply(questions, function(q) input[[paste0(key, "_", substr(q, nchar(key) + 2, nchar(q)))]])
      names(responses) <- questions
      update_csv(file_path, questions, responses, input$persona_id)
    }
    
    
  #########################
    
    # Combine all data
    combined_data(combine_files(file_paths(), input$persona_id))
    
    # Export combined data to CSV with persona_id as filename
    output_file_path <- paste0("/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/output/Persona_Scores/", input$persona_id, ".csv")
    write.csv(combined_data(), file = output_file_path, row.names = FALSE, na = "")
    
    output$response <- renderText("Thank you for your responses! They have been recorded. You can now download a csv of your responses.")
  })
  
  output$export_responses <- downloadHandler(
    filename = function() {
      paste0(input$persona_id, ".csv")
    },
    content = function(file) {
      write.csv(combined_data(), file, row.names = FALSE, na = "")
    }
  )
}
