# Define server logic for Page 4
server_page4 <- function(input, output, session) {
  observeEvent(input$submit, {

    # Paths to CSV files
    file_path_FIPS_I_RoadsTracks <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_I/FIPS_I_RoadsTracks.csv"
    file_path_FIPS_I_NationalCycleNetwork <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_I/FIPS_I_NationalCycleNetwork.csv"
    file_path_FIPS_I_NFERR <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_I/FIPS_I_NFERR.csv"
    file_path_FIPS_I_NFERA <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_I/FIPS_I_NFERA.csv"
    file_path_FIPS_I_LocalPathNetwork <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/FIPS_I/FIPS_I_LocalPathNetwork.csv"
    
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
    # FIPS_I
    # Road and Track Types responses
    questions_FIPS_I_RoadsTracks <- c(
      "FIPS_I_RoadsTracks_1",
      "FIPS_I_RoadsTracks_2",
      "FIPS_I_RoadsTracks_3",
      "FIPS_I_RoadsTracks_4",
      "FIPS_I_RoadsTracks_5"
    )
    responses_FIPS_I_RoadsTracks <- c(
      input$FIPS_I_RoadsTracks_1,
      input$FIPS_I_RoadsTracks_2,
      input$FIPS_I_RoadsTracks_3,
      input$FIPS_I_RoadsTracks_4,
      input$FIPS_I_RoadsTracks_5
    )
    names(responses_FIPS_I_RoadsTracks) <- questions_FIPS_I_RoadsTracks
    
    # National Cycle Network Surface Types responses
    questions_FIPS_I_NationalCycleNetwork <- c(
      "FIPS_I_NationalCycleNetwork_1",
      "FIPS_I_NationalCycleNetwork_2",
      "FIPS_I_NationalCycleNetwork_3",
      "FIPS_I_NationalCycleNetwork_4"
    )
    responses_FIPS_I_NationalCycleNetwork <- c(
      input$FIPS_I_NationalCycleNetwork_1,
      input$FIPS_I_NationalCycleNetwork_2,
      input$FIPS_I_NationalCycleNetwork_3,
      input$FIPS_I_NationalCycleNetwork_4
    )
    names(responses_FIPS_I_NationalCycleNetwork) <- questions_FIPS_I_NationalCycleNetwork
    
    # NFERR responses
    questions_FIPS_I_NFERR <- c(
      "FIPS_I_NFERR_1",
      "FIPS_I_NFERR_2",
      "FIPS_I_NFERR_3",
      "FIPS_I_NFERR_4",
      "FIPS_I_NFERR_5",
      "FIPS_I_NFERR_6",
      "FIPS_I_NFERR_7",
      "FIPS_I_NFERR_8",
      "FIPS_I_NFERR_9",
      "FIPS_I_NFERR_10"
    )
    responses_FIPS_I_NFERR <- c(
      input$FIPS_I_NFERR_1,
      input$FIPS_I_NFERR_2,
      input$FIPS_I_NFERR_3,
      input$FIPS_I_NFERR_4,
      input$FIPS_I_NFERR_5,
      input$FIPS_I_NFERR_6,
      input$FIPS_I_NFERR_7,
      input$FIPS_I_NFERR_8,
      input$FIPS_I_NFERR_9,
      input$FIPS_I_NFERR_10
    )
    names(responses_FIPS_I_NFERR) <- questions_FIPS_I_NFERR
    
    # NFERA responses
    questions_FIPS_I_NFERA <- c(
      "FIPS_I_NFERA_1",
      "FIPS_I_NFERA_2",
      "FIPS_I_NFERA_3",
      "FIPS_I_NFERA_4",
      "FIPS_I_NFERA_5",
      "FIPS_I_NFERA_6",
      "FIPS_I_NFERA_7",
      "FIPS_I_NFERA_8",
      "FIPS_I_NFERA_9",
      "FIPS_I_NFERA_10",
      "FIPS_I_NFERA_11",
      "FIPS_I_NFERA_12",
      "FIPS_I_NFERA_13",
      "FIPS_I_NFERA_14",
      "FIPS_I_NFERA_15",
      "FIPS_I_NFERA_16",
      "FIPS_I_NFERA_17"
    )
    responses_FIPS_I_NFERA <- c(
      input$FIPS_I_NFERA_1,
      input$FIPS_I_NFERA_2,
      input$FIPS_I_NFERA_3,
      input$FIPS_I_NFERA_4,
      input$FIPS_I_NFERA_5,
      input$FIPS_I_NFERA_6,
      input$FIPS_I_NFERA_7,
      input$FIPS_I_NFERA_8,
      input$FIPS_I_NFERA_9,
      input$FIPS_I_NFERA_10,
      input$FIPS_I_NFERA_11,
      input$FIPS_I_NFERA_12,
      input$FIPS_I_NFERA_13,
      input$FIPS_I_NFERA_14,
      input$FIPS_I_NFERA_15,
      input$FIPS_I_NFERA_16,
      input$FIPS_I_NFERA_17
    )
    names(responses_FIPS_I_NFERA) <- questions_FIPS_I_NFERA
    
    # Local Path Network responses
    questions_FIPS_I_LocalPathNetwork <- c(
      "FIPS_I_LocalPathNetwork_1",
      "FIPS_I_LocalPathNetwork_2"
    )
    responses_FIPS_I_LocalPathNetwork <- c(
      input$FIPS_I_LocalPathNetwork_1,
      input$FIPS_I_LocalPathNetwork_2
    )
    names(responses_FIPS_I_LocalPathNetwork) <- questions_FIPS_I_LocalPathNetwork

    ###
    
    # Update CSV files
    update_csv(file_path_FIPS_I_RoadsTracks, questions_FIPS_I_RoadsTracks, responses_FIPS_I_RoadsTracks, input$persona_id)
    update_csv(file_path_FIPS_I_NationalCycleNetwork, questions_FIPS_I_NationalCycleNetwork, responses_FIPS_I_NationalCycleNetwork, input$persona_id)
    update_csv(file_path_FIPS_I_NFERR, questions_FIPS_I_NFERR, responses_FIPS_I_NFERR, input$persona_id)
    update_csv(file_path_FIPS_I_NFERA, questions_FIPS_I_NFERA, responses_FIPS_I_NFERA, input$persona_id)
    update_csv(file_path_FIPS_I_LocalPathNetwork, questions_FIPS_I_LocalPathNetwork, responses_FIPS_I_LocalPathNetwork, input$persona_id)
    
  })
  
}