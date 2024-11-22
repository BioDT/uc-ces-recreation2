server_page4 <- function(input, output, session, all_form_data) {
  
  # Define questions for each dataset
  fips_i_questions <- list(
    FIPS_I_RoadsTracks = paste0("FIPS_I_RoadsTracks_", 1:5),
    FIPS_I_NationalCycleNetwork = paste0("FIPS_I_NationalCycleNetwork_", 1:4),
    FIPS_I_LocalPathNetwork = c("FIPS_I_LocalPathNetwork_2")
  )
  
  # Event handler for submit button
  observeEvent(input$submit, {
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Collect responses from the input fields
    all_responses <- unlist(lapply(fips_i_questions, function(qs) sapply(qs, function(q) input[[q]])))
    
    # Flatten the list manually to maintain correct names
    all_responses_flat <- unlist(all_responses, use.names = TRUE)
    
    # Split the names by the "." to remove the prefix (e.g. "SLSRA_CP." from "SLSRA_CP.SLSRA_CP_2")
    cleaned_names <- sub(".*\\.", "", names(all_responses_flat))
    
    # Create a data frame for this page's responses
    page4_data <- data.frame(
      Name = cleaned_names,
      Response = all_responses_flat,
      stringsAsFactors = FALSE
    )
    
    # Update global reactiveValues with page 4 data
    all_form_data$data <- rbind(all_form_data$data, page4_data)
    
    output$response <- renderText("Responses saved successfully!")
  })
}