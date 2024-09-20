# Define server logic for Page 1b
server_page1b <- function(input, output, session, persona_id_global) {
  
  observeEvent(input$submit_persona_id, {
    # Ensure Persona ID is provided
    if (input$persona_id == "") {
      output$response_sidebar <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Create a local variable
    persona_id <- input$persona_id
    
    # Update the reactiveValues object
    persona_id_global$input_text <- persona_id
    
    # Construct the file path to check
    folder_path <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/output/Persona_Scores/"
    file_to_check <- paste0(folder_path, persona_id, ".csv")  # Adjust extension as needed
    
    # Check if the file exists
    if (file.exists(file_to_check)) {
      output$response_sidebar <- renderText("This ID already exists. Please choose another.")
    } else {
      output$response_sidebar <- renderText("Persona ID is valid and available.")
    }
    
    # Print to console (optional)
    cat("Incoming global persona id:", persona_id, "\n")
    cat("File exists:", file.exists(file_to_check), "\n")  # Print file existence status
    
  })
}