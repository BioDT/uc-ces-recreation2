# Define server logic for Page 3
server_page3 <- function(input, output, session, all_form_data, persona_id_global) {
  
  # Define questions and responses in a list of lists
  fips_n_questions <- list(
    FIPS_N_Landform = paste0("FIPS_N_Landform_", 1:16),
    FIPS_N_Soil = paste0("FIPS_N_Soil_", 1:12),
    FIPS_N_Slope = paste0("FIPS_N_Slope_", 1:6)
  )
  
  
  # Event handler for submit button
  observeEvent(input$submit, {
    if (persona_id_global$input == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Collect responses from the input fields
    all_responses <- unlist(lapply(fips_n_questions, function(qs) sapply(qs, function(q) input[[q]])))
    
    # Flatten the list manually to maintain correct names
    all_responses_flat <- unlist(all_responses, use.names = TRUE)
    
    # Split the names by the "." to remove the prefix (e.g. "SLSRA_CP." from "SLSRA_CP.SLSRA_CP_2")
    cleaned_names <- sub(".*\\.", "", names(all_responses_flat))
    
    # Create a data frame for this page's responses
    page3_data <- data.frame(
      Name = cleaned_names,
      Response = all_responses_flat,
      stringsAsFactors = FALSE
    )
    
    # Update global reactiveValues with page 3 data
    all_form_data$data <- rbind(all_form_data$data, page3_data)
    
    output$response <- renderText("Responses saved successfully!")
  })
}