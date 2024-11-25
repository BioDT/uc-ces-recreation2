# Define server logic for Page 3
server_page3 <- function(input, output, session) {
  
  # Define file paths in a list
  file_paths <- list(
    FIPS_N_Landform = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion/input/FIPS_N/FIPS_N_Landform.csv",
    FIPS_N_NFI = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion/input/FIPS_N/FIPS_N_NFI.csv",
    FIPS_N_NWSS = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion/input/FIPS_N/FIPS_N_NWSS.csv",
    FIPS_N_Soil = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion/input/FIPS_N/FIPS_N_Soil.csv",
    FIPS_N_Slope = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion/input/FIPS_N/slope/FIPS_N_Slope.csv"
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
  fips_n_questions <- list(
    FIPS_N_Landform = paste0("FIPS_N_Landform_", 1:17),
    FIPS_N_NFI = paste0("FIPS_N_NFI_", 1:12),
    FIPS_N_NWSS = paste0("FIPS_N_NWSS_", 1:25),
    FIPS_N_Soil = paste0("FIPS_N_Soil_", 1:12),
    FIPS_N_Slope = paste0("FIPS_N_Slope_", 1:6)
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
    questions <- fips_n_questions[[key]]
    responses <- sapply(questions, function(q) input[[paste0(key, "_", substr(q, nchar(key) + 2, nchar(q)))]])
    names(responses) <- questions
    update_csv(file_path, questions, responses, input$persona_id)
  }

  })

}
  
  