# Define server logic for Page 4
server_page4 <- function(input, output, session) {
  
  # Define file paths in a list
  file_paths <- list(
    FIPS_I_RoadsTracks = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/FIPS_I/FIPS_I_RoadsTracks.csv",
    FIPS_I_NationalCycleNetwork = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/FIPS_I/FIPS_I_NationalCycleNetwork.csv",
    FIPS_I_LocalPathNetwork = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/FIPS_I/FIPS_I_LocalPathNetwork.csv"
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
  fips_i_questions <- list(
    FIPS_I_RoadsTracks = paste0("FIPS_I_RoadsTracks_", 1:5),
    FIPS_I_NationalCycleNetwork = paste0("FIPS_I_NationalCycleNetwork_", 1:4),
    FIPS_I_LocalPathNetwork = c("FIPS_I_LocalPathNetwork_2")
  )
  
  
  # Event handler for submit button
  observeEvent(input$submit, {
    # Ensure Persona ID is provided
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Loop through each file and update
    for (key in names(file_paths)) {
      file_path <- file_paths[[key]]
      questions <- fips_i_questions[[key]]
      responses <- sapply(questions, function(q) input[[paste0(key, "_", substr(q, nchar(key) + 2, nchar(q)))]])
      names(responses) <- questions
      update_csv(file_path, questions, responses, input$persona_id)
    }
    
  })
  
}