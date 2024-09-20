# Define server logic for Page 2
server_page2 <- function(input, output, session, form_data, csv_path) {
  
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
    for (key in names(slsra_questions)) {
      questions <- slsra_questions[[key]]  # List of questions
      
      # Collect the responses from the input fields (assumes input ID matches the question exactly)
      responses <- sapply(questions, function(q) input[[q]])
      
      # Update the form_data with the responses
      update_form_data(input$persona_id, questions, responses)
    }
    
    output$response <- renderText("Responses saved successfully!")
  })
}