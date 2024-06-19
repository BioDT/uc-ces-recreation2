# Define server logic for Page 2
server_page2 <- function(input, output, session, persona_id_global) {
  observeEvent(input$submit, {
    # Ensure Persona ID is provided
    if (input$persona_id == "") {
      output$response <- renderText("Please enter a Persona ID.")
      return()
    }
    
    # Create a local variable
    persona_id <- input$persona_id
    
    # Update the reactiveValues object
    persona_id_global$input_text <- persona_id
    
    # Paths to CSV files
    file_path_SLSRA_CP <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_CP.csv"
    file_path_SLSRA_HLUA <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_HLUA.csv"
    file_path_SLSRA_HNV <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_HNV.csv"
    file_path_SLSRA_LCM <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_LCM.csv"
    file_path_SLSRA_NNR <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_NNR.csv"
    file_path_SLSRA_NP <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_NP.csv"
    file_path_SLSRA_NR <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_NR.csv"
    file_path_SLSRA_RP <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_RP.csv"
    file_path_SLSRA_RSPB <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_RSPB.csv"
    file_path_SLSRA_SAC <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_SAC.csv"
    file_path_SLSRA_SPA <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_SPA.csv"
    file_path_SLSRA_SSSI <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_SSSI.csv"
    file_path_SLSRA_SWT <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_SWT.csv"
    file_path_SLSRA_WLA <- "/data/notebooks/rstudio-rp2r/testp/R_ShinyVersion/input/SLSRA/SLSRA_WLA.csv"
    
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
    
    
    # SLSRA
    # SLSRA_LCM responses
    questions_SLSRA_LCM <- c(
      "SLSRA_LCM_1",
      "SLSRA_LCM_2",
      "SLSRA_LCM_3",
      "SLSRA_LCM_4",
      "SLSRA_LCM_5",
      "SLSRA_LCM_6",
      "SLSRA_LCM_7",
      "SLSRA_LCM_8",
      "SLSRA_LCM_9",
      "SLSRA_LCM_10",
      "SLSRA_LCM_11",
      "SLSRA_LCM_12",
      "SLSRA_LCM_13",
      "SLSRA_LCM_14",
      "SLSRA_LCM_15",
      "SLSRA_LCM_16",
      "SLSRA_LCM_17",
      "SLSRA_LCM_18",
      "SLSRA_LCM_19",
      "SLSRA_LCM_20",
      "SLSRA_LCM_21",
      "SLSRA_LCM_22",
      "SLSRA_LCM_23",
      "SLSRA_LCM_24",
      "SLSRA_LCM_25",
      "SLSRA_LCM_26",
      "SLSRA_LCM_27",
      "SLSRA_LCM_28"
    )
    responses_SLSRA_LCM <- c(
      input$SLSRA_LCM_1,
      input$SLSRA_LCM_2,
      input$SLSRA_LCM_3,
      input$SLSRA_LCM_4,
      input$SLSRA_LCM_5,
      input$SLSRA_LCM_6,
      input$SLSRA_LCM_7,
      input$SLSRA_LCM_8,
      input$SLSRA_LCM_9,
      input$SLSRA_LCM_10,
      input$SLSRA_LCM_11,
      input$SLSRA_LCM_12,
      input$SLSRA_LCM_13,
      input$SLSRA_LCM_14,
      input$SLSRA_LCM_15,
      input$SLSRA_LCM_16,
      input$SLSRA_LCM_17,
      input$SLSRA_LCM_18,
      input$SLSRA_LCM_19,
      input$SLSRA_LCM_20,
      input$SLSRA_LCM_21,
      input$SLSRA_LCM_22,
      input$SLSRA_LCM_23,
      input$SLSRA_LCM_24,
      input$SLSRA_LCM_25,
      input$SLSRA_LCM_26,
      input$SLSRA_LCM_27,
      input$SLSRA_LCM_28
    )
    names(responses_SLSRA_LCM) <- questions_SLSRA_LCM
    
    # SLSRA_HLUA responses
    questions_SLSRA_HLUA <- c(
      "SLSRA_HLUA_1",
      "SLSRA_HLUA_2",
      "SLSRA_HLUA_3",
      "SLSRA_HLUA_4",
      "SLSRA_HLUA_5",
      "SLSRA_HLUA_6",
      "SLSRA_HLUA_7",
      "SLSRA_HLUA_8",
      "SLSRA_HLUA_9",
      "SLSRA_HLUA_10",
      "SLSRA_HLUA_11",
      "SLSRA_HLUA_12",
      "SLSRA_HLUA_13",
      "SLSRA_HLUA_14",
      "SLSRA_HLUA_15",
      "SLSRA_HLUA_16",
      "SLSRA_HLUA_17",
      "SLSRA_HLUA_18",
      "SLSRA_HLUA_19",
      "SLSRA_HLUA_20",
      "SLSRA_HLUA_21",
      "SLSRA_HLUA_22",
      "SLSRA_HLUA_23",
      "SLSRA_HLUA_24"
    )
    responses_SLSRA_HLUA <- c(
      input$SLSRA_HLUA_1,
      input$SLSRA_HLUA_2,
      input$SLSRA_HLUA_3,
      input$SLSRA_HLUA_4,
      input$SLSRA_HLUA_5,
      input$SLSRA_HLUA_6,
      input$SLSRA_HLUA_7,
      input$SLSRA_HLUA_8,
      input$SLSRA_HLUA_9,
      input$SLSRA_HLUA_10,
      input$SLSRA_HLUA_11,
      input$SLSRA_HLUA_12,
      input$SLSRA_HLUA_13,
      input$SLSRA_HLUA_14,
      input$SLSRA_HLUA_15,
      input$SLSRA_HLUA_16,
      input$SLSRA_HLUA_17,
      input$SLSRA_HLUA_18,
      input$SLSRA_HLUA_19,
      input$SLSRA_HLUA_20,
      input$SLSRA_HLUA_21,
      input$SLSRA_HLUA_22,
      input$SLSRA_HLUA_23,
      input$SLSRA_HLUA_24
    )
    names(responses_SLSRA_HLUA) <- questions_SLSRA_HLUA
    
    # SLSRA_HNV responses
    questions_SLSRA_HNV <- c(
      "SLSRA_HNV_1",
      "SLSRA_HNV_2"
    )
    responses_SLSRA_HNV <- c(
      input$SLSRA_HNV_1,
      input$SLSRA_HNV_2
    )
    names(responses_SLSRA_HNV) <- questions_SLSRA_HNV
    
    # SLSRA_CP responses
    questions_SLSRA_CP <- c(
      "SLSRA_CP_1",
      "SLSRA_CP_2"
    )
    responses_SLSRA_CP <- c(
      input$SLSRA_CP_1,
      input$SLSRA_CP_2
    )
    names(responses_SLSRA_CP) <- questions_SLSRA_CP   
    
    # SLSRA_NNR responses
    questions_SLSRA_NNR <- c(
      "SLSRA_NNR_1",
      "SLSRA_NNR_2"
    )
    responses_SLSRA_NNR <- c(
      input$SLSRA_NNR_1,
      input$SLSRA_NNR_2
    )
    names(responses_SLSRA_NNR) <- questions_SLSRA_NNR
    
    # SLSRA_NP responses
    questions_SLSRA_NP <- c(
      "SLSRA_NP_1",
      "SLSRA_NP_2"
    )
    responses_SLSRA_NP <- c(
      input$SLSRA_NP_1,
      input$SLSRA_NP_2
    )
    names(responses_SLSRA_NP) <- questions_SLSRA_NP
    
    # SLSRA_NR responses
    questions_SLSRA_NR <- c(
      "SLSRA_NR_1",
      "SLSRA_NR_2"
    )
    responses_SLSRA_NR <- c(
      input$SLSRA_NR_1,
      input$SLSRA_NR_2
    )
    names(responses_SLSRA_NR) <- questions_SLSRA_NR
    
    # SLSRA_RP responses
    questions_SLSRA_RP <- c(
      "SLSRA_RP_1",
      "SLSRA_RP_2"
    )
    responses_SLSRA_RP <- c(
      input$SLSRA_RP_1,
      input$SLSRA_RP_2
    )
    names(responses_SLSRA_RP) <- questions_SLSRA_RP
    
    # SLSRA_RSPB responses
    questions_SLSRA_RSPB <- c(
      "SLSRA_RSPB_1",
      "SLSRA_RSPB_2"
    )
    responses_SLSRA_RSPB <- c(
      input$SLSRA_RSPB_1,
      input$SLSRA_RSPB_2
    )
    names(responses_SLSRA_RSPB) <- questions_SLSRA_RSPB
    
    # SLSRA_SAC responses
    questions_SLSRA_SAC <- c(
      "SLSRA_SAC_1",
      "SLSRA_SAC_2"
    )
    responses_SLSRA_SAC <- c(
      input$SLSRA_SAC_1,
      input$SLSRA_SAC_2
    )
    names(responses_SLSRA_SAC) <- questions_SLSRA_SAC
    
    # SLSRA_SPA responses
    questions_SLSRA_SPA <- c(
      "SLSRA_SPA_1",
      "SLSRA_SPA_2"
    )
    responses_SLSRA_SPA <- c(
      input$SLSRA_SPA_1,
      input$SLSRA_SPA_2
    )
    names(responses_SLSRA_SPA) <- questions_SLSRA_SPA
    
    # SLSRA_SSSI responses
    questions_SLSRA_SSSI <- c(
      "SLSRA_SSSI_1",
      "SLSRA_SSSI_2"
    )
    responses_SLSRA_SSSI <- c(
      input$SLSRA_SSSI_1,
      input$SLSRA_SSSI_2
    )
    names(responses_SLSRA_SSSI) <- questions_SLSRA_SSSI
    
    # SLSRA_SWT responses
    questions_SLSRA_SWT <- c(
      "SLSRA_SWT_1",
      "SLSRA_SWT_2"
    )
    responses_SLSRA_SWT <- c(
      input$SLSRA_SWT_1,
      input$SLSRA_SWT_2
    )
    names(responses_SLSRA_SWT) <- questions_SLSRA_SWT
    
    # SLSRA_WLA responses
    questions_SLSRA_WLA <- c(
      "SLSRA_WLA_1",
      "SLSRA_WLA_2"
    )
    responses_SLSRA_WLA <- c(
      input$SLSRA_WLA_1,
      input$SLSRA_WLA_2
    )
    names(responses_SLSRA_WLA) <- questions_SLSRA_WLA

    ###
    
    # Update CSV files
    update_csv(file_path_SLSRA_CP, questions_SLSRA_CP, responses_SLSRA_CP, input$persona_id)
    update_csv(file_path_SLSRA_HLUA, questions_SLSRA_HLUA, responses_SLSRA_HLUA, input$persona_id)
    update_csv(file_path_SLSRA_HNV, questions_SLSRA_HNV, responses_SLSRA_HNV, input$persona_id)
    update_csv(file_path_SLSRA_LCM, questions_SLSRA_LCM, responses_SLSRA_LCM, input$persona_id)
    update_csv(file_path_SLSRA_NNR, questions_SLSRA_NNR, responses_SLSRA_NNR, input$persona_id)
    update_csv(file_path_SLSRA_NP, questions_SLSRA_NP, responses_SLSRA_NP, input$persona_id)
    update_csv(file_path_SLSRA_NR, questions_SLSRA_NR, responses_SLSRA_NR, input$persona_id)
    update_csv(file_path_SLSRA_RP, questions_SLSRA_RP, responses_SLSRA_RP, input$persona_id)
    update_csv(file_path_SLSRA_RSPB, questions_SLSRA_RSPB, responses_SLSRA_RSPB, input$persona_id)
    update_csv(file_path_SLSRA_SAC, questions_SLSRA_SAC, responses_SLSRA_SAC, input$persona_id)
    update_csv(file_path_SLSRA_SPA, questions_SLSRA_SPA, responses_SLSRA_SPA, input$persona_id)
    update_csv(file_path_SLSRA_SSSI, questions_SLSRA_SSSI, responses_SLSRA_SSSI, input$persona_id)
    update_csv(file_path_SLSRA_SWT, questions_SLSRA_SWT, responses_SLSRA_SWT, input$persona_id)
    update_csv(file_path_SLSRA_WLA, questions_SLSRA_WLA, responses_SLSRA_WLA, input$persona_id)
    
  })
  
}