# Define server logic for Page 2
server_page2 <- function(input, output, session) {
  
  # Define file paths in a list
  file_paths <- list(
    SLSRA_CP = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_CP.csv",
    SLSRA_HNV = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_HNV.csv",
    SLSRA_LCM = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_LCM.csv",
    SLSRA_NNR = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_NNR.csv",
    SLSRA_NP = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_NP.csv",
    SLSRA_NR = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_NR.csv",
    SLSRA_RP = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_RP.csv",
    SLSRA_RSPB = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_RSPB.csv",
    SLSRA_SAC = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_SAC.csv",
    SLSRA_SPA = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_SPA.csv",
    SLSRA_SSSI = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_SSSI.csv",
    SLSRA_SWT = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_SWT.csv",
    SLSRA_WLA = "/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/input/SLSRA/SLSRA_WLA.csv"
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
  slsra_questions <- list(
    SLSRA_CP = c("SLSRA_CP_2"),
    SLSRA_HNV = c("SLSRA_HNV_2"),
    SLSRA_LCM = paste0("SLSRA_LCM_", 1:28),
    SLSRA_NNR = c("SLSRA_NNR_2"),
    SLSRA_NP = c("SLSRA_NP_2"),
    SLSRA_NR = c("SLSRA_NR_2"),
    SLSRA_RP = c("SLSRA_RP_2"),
    SLSRA_RSPB = c("SLSRA_RSPB_2"),
    SLSRA_SAC = c("SLSRA_SAC_2"),
    SLSRA_SPA = c("SLSRA_SPA_2"),
    SLSRA_SSSI = c("SLSRA_SSSI_2"),
    SLSRA_SWT = c("SLSRA_SWT_2"),
    SLSRA_WLA = c("SLSRA_WLA_2")
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
      questions <- slsra_questions[[key]]
      responses <- sapply(questions, function(q) input[[paste0(key, "_", substr(q, nchar(key) + 2, nchar(q)))]])
      names(responses) <- questions
      update_csv(file_path, questions, responses, input$persona_id)
    }
  })
  
}
