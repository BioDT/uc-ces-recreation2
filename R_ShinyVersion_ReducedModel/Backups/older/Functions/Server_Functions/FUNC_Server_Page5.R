# Define server logic for Page 5
server_page5 <- function(input, output, session) {
  observeEvent(input$submit, {

    # Paths to CSV files
    file_path_Water_Lakes <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/Water/Water_Lakes.csv"
    file_path_Water_Rivers <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/Water/Water_Rivers.csv"
    
    # Function to update a CSV file
    update_csv <- function(file_path, questions, responses, persona_id) {
      if (!file.exists(file_path)) {
        stop(paste("The file", file_path, "does not exist."))
      }
      data <- read.csv(file_path, stringsAsFactors = FALSE, check.names = FALSE)
      
      if (persona_id %in% colnames(data)) {
        output$response <- renderText("This Persona ID already exists. Please use a different one.")
        return()
      }
      
      data[[persona_id]] <- NA  # Initialize new column with NA
      for (question in names(responses)) {
        row_index <- which(data[, 1] == question)
        if (length(row_index) > 0) {
          data[row_index, persona_id] <- responses[question]
        }
      }
      
      write.csv(data, file_path, row.names = FALSE, na = "")
    }
    
    ###
    # Water
    # Water_Rivers responses
    questions_Water_Rivers <- c(
      "Water_Rivers_1",
      "Water_Rivers_2",
      "Water_Rivers_3",
      "Water_Rivers_4",
      "Water_Rivers_5",
      "Water_Rivers_6",
      "Water_Rivers_7"
    )
    responses_Water_Rivers <- c(
      input$Water_Rivers_1,
      input$Water_Rivers_2,
      input$Water_Rivers_3,
      input$Water_Rivers_4,
      input$Water_Rivers_5,
      input$Water_Rivers_6,
      input$Water_Rivers_7
    )
    names(responses_Water_Rivers) <- questions_Water_Rivers
    
    # Water_Lakes responses
    questions_Water_Lakes <- c(
      "Water_Lakes_1",
      "Water_Lakes_2",
      "Water_Lakes_3",
      "Water_Lakes_4",
      "Water_Lakes_5",
      "Water_Lakes_6"
    )
    responses_Water_Lakes <- c(
      input$Water_Lakes_1,
      input$Water_Lakes_2,
      input$Water_Lakes_3,
      input$Water_Lakes_4,
      input$Water_Lakes_5,
      input$Water_Lakes_6
    )
    names(responses_Water_Lakes) <- questions_Water_Lakes

    ###
    
    # Update CSV files
    update_csv(file_path_Water_Lakes, questions_Water_Lakes, responses_Water_Lakes, input$persona_id)
    update_csv(file_path_Water_Rivers, questions_Water_Rivers, responses_Water_Rivers, input$persona_id)
    
    output$response <- renderText("Thank you for your responses! They have been recorded.")
  })
  
}