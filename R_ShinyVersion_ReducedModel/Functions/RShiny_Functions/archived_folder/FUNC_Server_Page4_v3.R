server_page4 <- function(input, output, session, form_data, csv_path) {
  # Define questions for each dataset
  fips_i_questions <- list(
    FIPS_I_RoadsTracks = paste0("FIPS_I_RoadsTracks_", 1:5),
    FIPS_I_NationalCycleNetwork = paste0("FIPS_I_NationalCycleNetwork_", 1:4),
    FIPS_I_LocalPathNetwork = c("FIPS_I_LocalPathNetwork_2")
  )
  
  # Function to update reactive values with form inputs
  update_form_data <- function(persona_id, questions, responses) {
    form_data_copy <- form_data()  # Get the current form_data
    
    # Update form_data based on the responses to questions
    for (i in seq_along(questions)) {
      question <- questions[i]
      response <- responses[[i]]
      
      # Match the question to the QuestionID and populate the persona_id column with the response
      form_data_copy[form_data_copy$QuestionID == question, persona_id] <- response
    }
    
    form_data(form_data_copy)  # Update reactive form_data with modified copy
  }
  
  # Event handler for submit button
  observeEvent(input$submit, {
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Loop through the Water questions and collect responses
    for (key in names(fips_i_questions)) {
      questions <- fips_i_questions[[key]]  # List of questions
      
      # Collect the responses from the input fields (assumes input ID matches the question exactly)
      responses <- sapply(questions, function(q) input[[q]])
      
      # Update the form_data with the responses
      update_form_data(input$persona_id, questions, responses)
    }
    
    output$response <- renderText("Responses saved successfully!")
})
}