
# lines with info tagged with e.g. ### xyz ### 
# are edited from original GIT code to work in this env

# Set the base working directory
setwd("/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore")  ### added filepath to work ###


##############################################
###                VARIABLES               ###
##############################################
#args <- commandArgs(TRUE)
#if (length(args) == 0) {
#  stop("Please supply a score column to use as a command-line argument.")
#}
# score column to be used throughout to score rasters
#Score_column <- args[1]
Score_column <- "HR"  ### couldn't get the args to work so used old version to select score column ###

# input directory
input_folder <- "/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore/input"  ### added filepath to work ###
# output directory
output_folder <- "/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore/output"  ### added filepath to work ###
# output boundaries
target_shapefile <- "/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore/input/boundaries.shp"  ### added filepath to work ###
# empty raster name
empty_raster <- "/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore/input/empty.tif"  ### added filepath to work ###
# Set maximum distance for the proximity in meters.  Is 1500 correct??
max_distance <- 1500

#################################################
### SETUP THE ENVIRONMENT AND COMMON FEATURES ###
#################################################
# load libraries
library(raster)
library(tools)

# call any functions to the environment
source("FUNC_Raster_Reclassifier.R")
source("FUNC_Process_Raster_Proximity.R")
source("FUNC_Calculate_Euclidean_Distance.R")
source("FUNC_Normalise_Rasters.R")

#setwd(input_folder)
#setwd("/input")

# load in the shapefile mask
mask_boundary <- shapefile(target_shapefile)
# plot(mask_boundary)
# import empty raster for resolution
# TODO: generate from "mask" shapefile
Raster_Empty <- raster(empty_raster)
values(Raster_Empty) <- 0
# Set the common CRS (GB grid) using the empty raster
#common_crs <- crs(Raster_Empty)

##############################################
### COMPONENT 1 - COMPUTE NORMALIZED SLSRA ###
##############################################
# firstly reclassify the unscored rasters with the correct score using the function: FUNC_Raster_Reclassifier 
# Set the folder paths here
raster_folder <- "/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore/input/SLSRA"  ### added filepath to work ###

# Call the function to reclassify rasters by score
modified_rasters <- reclassify_rasters(raster_folder, Score_column)

# Normalize the sum raster to a scale of 0-1
SLSRA_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
# plot(SLSRA_Norm)

# Write the output raster
writeRaster(SLSRA_Norm, file.path(output_folder, paste0("Component_SLSRA_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)

###############################################
### COMPONENT 2 - COMPUTE NORMALIZED FIPS_N ###
###############################################
# firstly reclassify the un-scored rasters with the correct score using the function: FUNC_Raster_Reclassifier
# Set the folder paths here
raster_folder <- "/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore/input/FIPS_N" ### added filepath to work ###
slope_folder <- file.path(raster_folder, "slope")

# Call the function to reclassify rasters by score
modified_rasters <- reclassify_rasters(raster_folder, Score_column)

# Slope needs to be dealt with differently due to grouped output having issues in main function.
slope_df <- data.frame(
  group_val_min = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
  group_val_max = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
  score = read.csv(file.path(slope_folder,"Raster_FIPS_N_Slope.csv"))[[Score_column]]
)
reclass_m <- data.matrix(slope_df)

Slope_Raster <- raster(file.path(slope_folder,"Raster_FIPS_N_Slope.tif"))
modified_rasters[["slope"]] <-  reclassify(Slope_Raster, reclass_m)

FIPS_N_Norm <- normalise_rasters(modified_rasters, Raster_Empty)

# Write the output raster
writeRaster(FIPS_N_Norm, file.path(output_folder, paste0("Component_FIPS_N_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)

###############################################
### COMPONENT 3 - COMPUTE NORMALIZED FIPS_I ###
###############################################
# firstly reclassify the un-scored rasters with the correct score using the function: FUNC_Raster_Reclassifier
# Set the folder paths here
raster_folder <- "/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore/input/FIPS_I"

# Call the function to reclassify rasters by score
modified_rasters <- reclassify_rasters(raster_folder, Score_column)

# modify each raster by processing proximity
modified_rasters <- lapply(modified_rasters, process_raster_proximity, max_distance)

# modify each raster by euclidean distance
modified_rasters <- lapply(modified_rasters, calculate_euclidean_distance)

# normalise
modified_rasters <- lapply(modified_rasters, normalise_rasters, Raster_Empty)

# Clip the sum raster by the shapefile
modified_rasters <- lapply(modified_rasters, mask, mask_boundary)

FIPS_I_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
writeRaster(FIPS_I_Norm, file.path(output_folder, paste0("Component_FIPS_I_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)

###############################################
### COMPONENT 4 - COMPUTE NORMALIZED Water ###
###############################################
# firstly reclassify the un-scored rasters with the correct score using the function: FUNC_Raster_Reclassifier
# Set the folder paths here
raster_folder <- "/data/notebooks/rstudio-rp2r/testp/GIT_RastersPreScore/input/Water"   ### added filepath to work ###

# Call the function to reclassify rasters by score
modified_rasters <- reclassify_rasters(raster_folder, Score_column)

# modify each raster by processing proximity
modified_rasters <- lapply(modified_rasters, process_raster_proximity, max_distance)

# modify each raster by euclidean distance
modified_rasters <- lapply(modified_rasters, calculate_euclidean_distance)

# normalise
modified_rasters <- lapply(modified_rasters, normalise_rasters, Raster_Empty)

# Clip the sum raster by the shapefile
modified_rasters <- lapply(modified_rasters, mask, mask_boundary)

Water_Norm <- normalise_rasters(modified_rasters, Raster_Empty)
writeRaster(Water_Norm, file.path(output_folder, paste0("Component_Water_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)

#############################################
### Compute and normalise final RP Model ###
#############################################
# Get the list SLSRA component rasters located in the folder SLSRA folder
raster_files <- list.files(output_folder, pattern = "^Component_", full.names = TRUE)

# Filter the raster files based on the two-letter code in Score_column
raster_files <- raster_files[grepl(paste0(Score_column, ".tif$"), basename(raster_files))]

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
writeRaster(BioDT_RP_Norm, file.path(output_folder, paste0("recreation_potential_", Score_column, ".tif")), format = "GTiff", overwrite = TRUE)
