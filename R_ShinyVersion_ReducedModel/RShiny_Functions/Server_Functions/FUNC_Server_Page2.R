# Define server logic for Page 2
server_page2 <- function(input, output, session, all_form_data) {
  
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
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Collect responses from the input fields
    all_responses <- unlist(lapply(slsra_questions, function(qs) sapply(qs, function(q) input[[q]])))
    
    # Flatten the list manually to maintain correct names
    all_responses_flat <- unlist(all_responses, use.names = TRUE)
    
    # Split the names by the "." to remove the prefix (e.g. "SLSRA_CP." from "SLSRA_CP.SLSRA_CP_2")
    cleaned_names <- sub(".*\\.", "", names(all_responses_flat))
    
    # Create a data frame for this page's responses
    page2_data <- data.frame(
      Name = cleaned_names,
      Response = all_responses_flat,
      stringsAsFactors = FALSE
    )
    
    # Update global reactiveValues with page 2 data
    all_form_data$data <- rbind(all_form_data$data, page2_data)
    
    output$response <- renderText("Responses saved successfully!")
  })
}