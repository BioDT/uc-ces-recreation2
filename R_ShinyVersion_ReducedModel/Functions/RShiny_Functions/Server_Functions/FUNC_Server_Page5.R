server_page5 <- function(input, output, session, all_form_data, form_data, csv_path, home_folder) {
 
  ### FIRST PART IS RELATED TO PARAMETERIZATION (AS FOR PAGE 2-4) ###
  
  # Define Water component questions and responses
  water_questions <- list(
    Water_Lakes = paste0("Water_Lakes_", 1:6),
    Water_Rivers = paste0("Water_Rivers_", 1:7)
  )
  
  # Reactive value to store the updated form_data
  updated_form_data <- reactiveVal(NULL)
  
  # Event handler for submit button
  observeEvent(input$submit, {
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
      
    
    # Collect responses from the input fields
    all_responses <- unlist(lapply(water_questions, function(qs) sapply(qs, function(q) input[[q]])))
    
    # Flatten the list manually to maintain correct names
    all_responses_flat <- unlist(all_responses, use.names = TRUE)
    
    # Split the names by the "." to remove the prefix (e.g. "SLSRA_CP." from "SLSRA_CP.SLSRA_CP_2")
    cleaned_names <- sub(".*\\.", "", names(all_responses_flat))
    
    # Create a data frame for this page's responses
    page5_data <- data.frame(
      Name = cleaned_names,
      Response = all_responses_flat,
      stringsAsFactors = FALSE
    )
    
    # Update global reactiveValues with page 5 data
    all_form_data$data <- rbind(all_form_data$data, page5_data)
    
    ### SECOND PART IS BRINGING THE FORM INPUTS TOGETHER FOR SAVING AND ONWARD USE ###
    
    # Load or use the existing form_data (the original CSV file)
    form_data_copy <- form_data()  # Assuming form_data is a reactive value holding the data from the CSV
    
    # Add a new column for the persona_id if it doesn't exist
    if (!(input$persona_id %in% colnames(form_data_copy))) {
      form_data_copy[[input$persona_id]] <- NA
    }
    
    # Iterate over all entries in all_form_data$data (which now includes all pages' responses)
    for (i in 1:nrow(all_form_data$data)) {
      name <- all_form_data$data$Name[i]
      response <- all_form_data$data$Response[i]
      
      # Find the row in form_data where the 'Name' matches the question name from all_form_data$data
      matching_row <- form_data_copy$Name == name
      if (any(matching_row)) {
        form_data_copy[matching_row, input$persona_id] <- response
      }
    }
    
    # Store the updated form_data in the reactive value
    updated_form_data(form_data_copy)
    
    # Export the updated form_data as a CSV
    write.csv(form_data_copy, 
              paste0(home_folder, "Data/input/Persona_Loaded/", input$persona_id, ".csv"), 
              row.names = FALSE, na = "")
    
    output$response <- renderText("All responses saved and exported successfully!")
  })
  
    
  # Download handler to export the final form_data as a CSV file
  output$export_responses <- downloadHandler(
    filename = function() {
      paste0(input$persona_id, "_final_responses.csv")
    },
    content = function(file) {
      # Use the updated form_data stored in the reactive value
      write.csv(updated_form_data(), file, row.names = FALSE, na = "")
    }
  )
}