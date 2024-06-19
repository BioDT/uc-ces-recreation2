# Define server logic for Page 3
server_page3 <- function(input, output, session) {
  observeEvent(input$submit, {

    # Paths to CSV files
    file_path_FIPS_N_Landform <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_N/FIPS_N_Landform.csv"
    file_path_FIPS_N_NFI <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_N/FIPS_N_NFI.csv"
    file_path_FIPS_N_NWSS <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_N/FIPS_N_NWSS.csv"
    file_path_FIPS_N_Soil <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_N/FIPS_N_Soil.csv"
    file_path_FIPS_N_Slope <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_N/slope/FIPS_N_Slope.csv"
    
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
    # FIPS_N
    # Landform responses
    questions_FIPS_N_Landform <- c(
      "FIPS_N_Landform_1",
      "FIPS_N_Landform_2",
      "FIPS_N_Landform_3",
      "FIPS_N_Landform_4",
      "FIPS_N_Landform_5",
      "FIPS_N_Landform_6",
      "FIPS_N_Landform_7",
      "FIPS_N_Landform_8",
      "FIPS_N_Landform_9",
      "FIPS_N_Landform_10",
      "FIPS_N_Landform_11",
      "FIPS_N_Landform_12",
      "FIPS_N_Landform_13",
      "FIPS_N_Landform_14",
      "FIPS_N_Landform_15",
      "FIPS_N_Landform_16",
      "FIPS_N_Landform_17"
    )
    responses_FIPS_N_Landform <- c(
      input$FIPS_N_Landform_1,
      input$FIPS_N_Landform_2,
      input$FIPS_N_Landform_3,
      input$FIPS_N_Landform_4,
      input$FIPS_N_Landform_5,
      input$FIPS_N_Landform_6,
      input$FIPS_N_Landform_7,
      input$FIPS_N_Landform_8,
      input$FIPS_N_Landform_9,
      input$FIPS_N_Landform_10,
      input$FIPS_N_Landform_11,
      input$FIPS_N_Landform_12,
      input$FIPS_N_Landform_13,
      input$FIPS_N_Landform_14,
      input$FIPS_N_Landform_15,
      input$FIPS_N_Landform_16,
      input$FIPS_N_Landform_17
    )
    names(responses_FIPS_N_Landform) <- questions_FIPS_N_Landform
    
    # FIPS_N_NFI responses
    questions_FIPS_N_NFI <- c(
      "FIPS_N_NFI_1",
      "FIPS_N_NFI_2",
      "FIPS_N_NFI_3",
      "FIPS_N_NFI_4",
      "FIPS_N_NFI_5",
      "FIPS_N_NFI_6",
      "FIPS_N_NFI_7",
      "FIPS_N_NFI_8",
      "FIPS_N_NFI_9",
      "FIPS_N_NFI_10",
      "FIPS_N_NFI_11",
      "FIPS_N_NFI_12",
      "FIPS_N_NFI_13",
      "FIPS_N_NFI_14",
      "FIPS_N_NFI_15",
      "FIPS_N_NFI_16",
      "FIPS_N_NFI_17",
      "FIPS_N_NFI_18",
      "FIPS_N_NFI_19",
      "FIPS_N_NFI_20",
      "FIPS_N_NFI_21",
      "FIPS_N_NFI_22",
      "FIPS_N_NFI_23"
    )
    responses_FIPS_N_NFI <- c(
      input$FIPS_N_NFI_1,
      input$FIPS_N_NFI_2,
      input$FIPS_N_NFI_3,
      input$FIPS_N_NFI_4,
      input$FIPS_N_NFI_5,
      input$FIPS_N_NFI_6,
      input$FIPS_N_NFI_7,
      input$FIPS_N_NFI_8,
      input$FIPS_N_NFI_9,
      input$FIPS_N_NFI_10,
      input$FIPS_N_NFI_11,
      input$FIPS_N_NFI_12,
      input$FIPS_N_NFI_13,
      input$FIPS_N_NFI_14,
      input$FIPS_N_NFI_15,
      input$FIPS_N_NFI_16,
      input$FIPS_N_NFI_17,
      input$FIPS_N_NFI_18,
      input$FIPS_N_NFI_19,
      input$FIPS_N_NFI_20,
      input$FIPS_N_NFI_21,
      input$FIPS_N_NFI_22,
      input$FIPS_N_NFI_23
    )
    names(responses_FIPS_N_NFI) <- questions_FIPS_N_NFI
    
    # FIPS_N_NWSS responses
    questions_FIPS_N_NWSS <- c(
      "FIPS_N_NWSS_1",
      "FIPS_N_NWSS_2",
      "FIPS_N_NWSS_3",
      "FIPS_N_NWSS_4",
      "FIPS_N_NWSS_5",
      "FIPS_N_NWSS_6",
      "FIPS_N_NWSS_7",
      "FIPS_N_NWSS_8",
      "FIPS_N_NWSS_9",
      "FIPS_N_NWSS_10",
      "FIPS_N_NWSS_11",
      "FIPS_N_NWSS_12",
      "FIPS_N_NWSS_13",
      "FIPS_N_NWSS_14",
      "FIPS_N_NWSS_15",
      "FIPS_N_NWSS_16",
      "FIPS_N_NWSS_17",
      "FIPS_N_NWSS_18",
      "FIPS_N_NWSS_19",
      "FIPS_N_NWSS_20",
      "FIPS_N_NWSS_21",
      "FIPS_N_NWSS_22",
      "FIPS_N_NWSS_23",
      "FIPS_N_NWSS_24",
      "FIPS_N_NWSS_25"
    )
    responses_FIPS_N_NWSS <- c(
      input$FIPS_N_NWSS_1,
      input$FIPS_N_NWSS_2,
      input$FIPS_N_NWSS_3,
      input$FIPS_N_NWSS_4,
      input$FIPS_N_NWSS_5,
      input$FIPS_N_NWSS_6,
      input$FIPS_N_NWSS_7,
      input$FIPS_N_NWSS_8,
      input$FIPS_N_NWSS_9,
      input$FIPS_N_NWSS_10,
      input$FIPS_N_NWSS_11,
      input$FIPS_N_NWSS_12,
      input$FIPS_N_NWSS_13,
      input$FIPS_N_NWSS_14,
      input$FIPS_N_NWSS_15,
      input$FIPS_N_NWSS_16,
      input$FIPS_N_NWSS_17,
      input$FIPS_N_NWSS_18,
      input$FIPS_N_NWSS_19,
      input$FIPS_N_NWSS_20,
      input$FIPS_N_NWSS_21,
      input$FIPS_N_NWSS_22,
      input$FIPS_N_NWSS_23,
      input$FIPS_N_NWSS_24,
      input$FIPS_N_NWSS_25
    )
    names(responses_FIPS_N_NWSS) <- questions_FIPS_N_NWSS
    
    # FIPS_N_Soil responses
    questions_FIPS_N_Soil <- c(
      "FIPS_N_Soil_1",
      "FIPS_N_Soil_2",
      "FIPS_N_Soil_3",
      "FIPS_N_Soil_4",
      "FIPS_N_Soil_5",
      "FIPS_N_Soil_6",
      "FIPS_N_Soil_7",
      "FIPS_N_Soil_8",
      "FIPS_N_Soil_9",
      "FIPS_N_Soil_10",
      "FIPS_N_Soil_11",
      "FIPS_N_Soil_12"
    )
    responses_FIPS_N_Soil <- c(
      input$FIPS_N_Soil_1,
      input$FIPS_N_Soil_2,
      input$FIPS_N_Soil_3,
      input$FIPS_N_Soil_4,
      input$FIPS_N_Soil_5,
      input$FIPS_N_Soil_6,
      input$FIPS_N_Soil_7,
      input$FIPS_N_Soil_8,
      input$FIPS_N_Soil_9,
      input$FIPS_N_Soil_10,
      input$FIPS_N_Soil_11,
      input$FIPS_N_Soil_12
    )
    names(responses_FIPS_N_Soil) <- questions_FIPS_N_Soil
    
    # FIPS_N_Slope responses
    questions_FIPS_N_Slope <- c(
      "FIPS_N_Slope_1",
      "FIPS_N_Slope_2",
      "FIPS_N_Slope_3",
      "FIPS_N_Slope_4",
      "FIPS_N_Slope_5",
      "FIPS_N_Slope_6"
    )
    responses_FIPS_N_Slope <- c(
      input$FIPS_N_Slope_1,
      input$FIPS_N_Slope_2,
      input$FIPS_N_Slope_3,
      input$FIPS_N_Slope_4,
      input$FIPS_N_Slope_5,
      input$FIPS_N_Slope_6
    )
    names(responses_FIPS_N_Slope) <- questions_FIPS_N_Slope

    ###
    
    # Update CSV files
    update_csv(file_path_FIPS_N_Landform, questions_FIPS_N_Landform, responses_FIPS_N_Landform, input$persona_id)
    update_csv(file_path_FIPS_N_NFI, questions_FIPS_N_NFI, responses_FIPS_N_NFI, input$persona_id)
    update_csv(file_path_FIPS_N_NWSS, questions_FIPS_N_NWSS, responses_FIPS_N_NWSS, input$persona_id)
    update_csv(file_path_FIPS_N_Soil, questions_FIPS_N_Soil, responses_FIPS_N_Soil, input$persona_id)
    update_csv(file_path_FIPS_N_Slope, questions_FIPS_N_Slope, responses_FIPS_N_Slope, input$persona_id)

  })
  
}