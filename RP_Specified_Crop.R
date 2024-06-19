# FULL MODEL RUN TAKES ABOUT 6HRS 10MINS ON DATALABS
# SLSRA, FIPS_N, FINAL_RP = ABOUT 0-2 MINS EACH
# FIPS_I = 3HRS 30MIN
# WATER = 2HRS 30MIN
###################

# lines with info tagged with e.g. ### xyz ### 
# are edited from original GIT code to work in this env

# Clear the memory
rm(list = ls())

#################################################
### SETUP THE ENVIRONMENT AND COMMON FEATURES ###
#################################################
# load libraries
library(raster)
library(tools)
library(sf)
library(dplyr)

# Set the base working directory
setwd("/data/notebooks/rstudio-rp2r/testp/RP_Scotland")  ### added filepath to work ###

# call any functions to the environment
source("FUNC_Raster_Reclassifier.R")
source("FUNC_Process_Raster_Proximity2.R")
source("FUNC_Calculate_Euclidean_Distance.R")
source("FUNC_Normalise_Rasters.R")
source("FUNC_Crop_Rasters_by_mask.R")
source("FUNC_Skip_Prox_on_Rasters_Without_NA.R")
source("FUNC_Process_Area_of_Interest.R")


###############################################
###                VARIABLES 1              ###
###############################################

# Provide an existing Persona ID.  Currently SR, HR or NL 
Score_column <- "SR"

# Provide a name for the area of interest. It MUST also be part of the input shapefile name
Boundary_name <- "Inshriach" ### short descriptive name of boundary region to be included in output names

# input directory
input_folder <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input"  ### added filepath to work ###

# output directory
output_folder <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/output"  ### added filepath to work ###

# Set the location of the raw shapefiles
Raw_Shapefile <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/Raw_Shapefile/"

# Set the resolution of the XY datasets (should be 20 to match input raster data of 20 m x 20 m)
resolution <- 20

# Set the max distance for the draw of water ways and roads on RP # currently using 1500 m
max_distance <- 1500


##############################################
###           Area of Interest             ###
##############################################

# this section takes a shapefile and sets the crs, replaces existing boundaries file and creates the empty raster
# Call the function
area_of_interest <- process_area_of_interest(Raw_Shapefile, Boundary_name, input_folder, resolution, max_distance)

# Extract the results
Raster_Empty <- area_of_interest$Raster_Empty
mask_boundary <- area_of_interest$mask_boundary

##############################################
### COMPONENT 1 - COMPUTE NORMALIZED SLSRA ###
##############################################

# firstly reclassify the unscored rasters with the correct score using the function: FUNC_Raster_Reclassifier 
# Set the folder paths here
raster_folder <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/SLSRA"  ### added filepath to work ###

# Call the functions to crop the rasters
cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)

# Call the function to reclassify rasters by score
modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, Score_column)

# Normalize the sum raster to a scale of 0-1
SLSRA_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
SLSRA_Norm <- mask(SLSRA_Norm, mask_boundary)

# Write the output raster
writeRaster(SLSRA_Norm, file.path(output_folder, paste0("Component_SLSRA_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)


###############################################
### COMPONENT 2 - COMPUTE NORMALIZED FIPS_N ###
###############################################

# firstly reclassify the un-scored rasters with the correct score using the function: FUNC_Raster_Reclassifier
# Set the folder paths here
raster_folder <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_N" ### added filepath to work ###
slope_folder <- file.path(raster_folder, "slope")

# Call the functions to crop the rasters
cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)

# Call the function to reclassify rasters by score
modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, Score_column)

# Slope needs to be dealt with differently due to grouped output having issues in main function.
slope_df <- data.frame(
  group_val_min = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
  group_val_max = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
  score = read.csv(file.path(slope_folder,"FIPS_N_Slope.csv"))[[Score_column]]
)
reclass_m <- data.matrix(slope_df)

Slope_Raster <- raster(file.path(slope_folder,"FIPS_N_Slope.tif"))
Slope_Raster <- crop(Slope_Raster, Raster_Empty)
modified_rasters[["slope"]] <-  reclassify(Slope_Raster, reclass_m)

# Normalize the sum raster to a scale of 0-1
FIPS_N_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
FIPS_N_Norm <- mask(FIPS_N_Norm, mask_boundary)

# Write the output raster
writeRaster(FIPS_N_Norm, file.path(output_folder, paste0("Component_FIPS_N_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)


###############################################
### COMPONENT 3 - COMPUTE NORMALIZED FIPS_I ###
###############################################

# firstly reclassify the un-scored rasters with the correct score using the function: FUNC_Raster_Reclassifier
# Set the folder paths here
raster_folder <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/FIPS_I"

# Call the functions to crop the rasters
cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)

# Call the function to reclassify rasters by score
modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, Score_column)

# modify each raster by processing proximity
modified_rasters <- lapply(modified_rasters, process_raster_proximity, max_distance)

# modify each raster by euclidean distance
modified_rasters <- lapply(modified_rasters, calculate_euclidean_distance)

# normalise 
modified_rasters <- lapply(modified_rasters, normalise_rasters, Raster_Empty)

# Clip the sum raster by the shapefile
modified_rasters <- lapply(modified_rasters, mask, mask_boundary)

FIPS_I_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
FIPS_I_Norm <- mask(FIPS_I_Norm, mask_boundary)

writeRaster(FIPS_I_Norm, file.path(output_folder, paste0("Component_FIPS_I_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)


###############################################
### COMPONENT 4 - COMPUTE NORMALIZED Water ###
###############################################

# firstly reclassify the un-scored rasters with the correct score using the function: FUNC_Raster_Reclassifier
# Set the folder paths here
raster_folder <- "/data/notebooks/rstudio-rp2r/testp/RP_Scotland/input/Water"   ### added filepath to work ###

# Call the functions to crop the rasters
cropped_rasters <- crop_rasters_by_mask(raster_folder, Raster_Empty)

# Call the function to reclassify rasters by score
modified_rasters <- reclassify_rasters(cropped_rasters, raster_folder, Score_column)

# modify each raster by processing proximity
modified_rasters <- lapply(modified_rasters, process_raster_proximity, max_distance)

# modify each raster by euclidean distance
modified_rasters <- lapply(modified_rasters, calculate_euclidean_distance)

# normalise
modified_rasters <- lapply(modified_rasters, normalise_rasters, Raster_Empty)

# Clip the sum raster by the shapefile
modified_rasters <- lapply(modified_rasters, mask, mask_boundary)

Water_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
Water_Norm <- mask(Water_Norm, mask_boundary)

writeRaster(Water_Norm, file.path(output_folder, paste0("Component_Water_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)


#############################################
### Compute and normalise final RP Model ###
#############################################

# Get the list SLSRA component rasters located in the folder SLSRA folder
raster_files <- list.files(output_folder, pattern = "^Component_", full.names = TRUE)

# Filter the raster files based on the two-letter code in Score_column
raster_files <- raster_files[grepl(paste0(Boundary_name,"_",Score_column, ".tif$"), basename(raster_files))]

# Initialize an empty raster to store the sum
sum_raster <- Raster_Empty

# Loop through each raster file
for (file in raster_files) {
  # Read the raster and set the CRS
  raster <- raster(file)
  #  raster <- projectRaster(raster, crs = common_crs)
  #
  #  # Resample the raster to match the resolution of the empty raster
  #  raster <- resample(raster, sum_raster, method = "bilinear")
  #
  # Add the raster values to the sum raster
  sum_raster <- sum_raster + raster
}

# Normalize the sum raster to a scale of 0-1
BioDT_RP_Norm  <- (sum_raster - min(sum_raster[], na.rm = TRUE)) /
  (max(sum_raster[], na.rm = TRUE) - min(sum_raster[], na.rm = TRUE))

#Clip the raster by the mask
BioDT_RP_Norm <- mask(BioDT_RP_Norm, mask_boundary)

# Write the output raster
writeRaster(BioDT_RP_Norm, file.path(output_folder, paste0("recreation_potential_", Boundary_name, "_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)

