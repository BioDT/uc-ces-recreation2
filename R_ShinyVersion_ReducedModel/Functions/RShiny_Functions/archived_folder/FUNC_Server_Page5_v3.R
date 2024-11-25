server_page5 <- function(input, output, session, form_data, csv_path) {
  
  # Define Water component questions and responses
  Name <- list(
    Water_Lakes = paste0("Water_Lakes_", 1:6),
    Water_Rivers = paste0("Water_Rivers_", 1:7)
  )
  
  update_form_data <- function(persona_id, questions, responses) {
    form_data_copy <- form_data()  # Get the current form_data
    
    # Ensure the persona_id column exists
    if (!persona_id %in% colnames(form_data_copy)) {
      form_data_copy[[persona_id]] <- NA  # Initialize the column if it doesn't exist
    }
    
    # Update form_data based on the responses to questions
    for (i in seq_along(questions)) {
      question <- questions[i]
      response <- responses[[i]]
      
      # Debugging output
      print(paste("Updating:", question, "with response:", response))
      
      if (question %in% form_data_copy$Name) {
        # Update the persona_id column with the response
        form_data_copy[form_data_copy$Name == question, persona_id] <- response
      } else {
        warning(paste("Question not found in form_data:", question))
      }
    }
    
    form_data(form_data_copy)  # Update reactive form_data with modified copy
  }
  
  observeEvent(input$submit, {
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    for (key in names(Name)) {
      questions <- Name[[key]]  # List of questions
      responses <- sapply(questions, function(q) input[[q]], simplify = FALSE)
      
      # Debugging output
      print(paste("Questions:", paste(questions, collapse = ", ")))
      print(paste("Responses:", paste(unlist(responses), collapse = ", ")))
      
      update_form_data(input$persona_id, questions, responses)
    }
    
    output$response <- renderText("Responses saved successfully!")
    
    # Export the updated form_data as a CSV
    write.csv(form_data(), paste0("/data/notebooks/rstudio-rpmodel/testp/R_ShinyVersion_ReducedModel/output/Persona_Scores/", input$persona_id, ".csv"), row.names = FALSE, na = "")
  })
  
  # Download handler to export the responses as a CSV file
  output$export_responses <- downloadHandler(
    filename = function() {
      paste0(input$persona_id, ".csv")
    },
    content = function(file) {
      write.csv(form_data(), file, row.names = FALSE, na = "")
    }
  )
}