#### function to list all the shapefiles in the folder
## used in server page 1
list_shapefiles <- function(dir) {
  shapefile_paths <- list.files(dir, pattern = "\\.shp$", full.names = TRUE, recursive = TRUE)
  if (length(shapefile_paths) == 0) {
    return(NULL)
  }
  shapefile_names <- basename(shapefile_paths)
  shapefile_names <- tools::file_path_sans_ext(shapefile_names) 
  names(shapefile_paths) <- shapefile_names
  return(shapefile_paths)
}

# function to list personas which already exist
## used in server page 1b
list_persona_files <- function(dir) {
  persona_paths <- list.files(dir, pattern = "\\.csv$", full.names = TRUE)
  if (length(persona_paths) == 0) {
    return(NULL)
  }
  persona_names <- basename(persona_paths)
  persona_names <- tools::file_path_sans_ext(persona_names)
  names(persona_paths) <- persona_names
  return(persona_paths)
}

#function to calculate the time difference
calculate_time_diff <- function(start_time, end_time) {
  # Calculate the time difference in seconds
  time_diff_secs <- as.numeric(difftime(end_time, start_time, units = "secs"))
  # Calculate hours, minutes, and seconds
  hours <- floor(time_diff_secs / 3600)
  minutes <- floor((time_diff_secs %% 3600) / 60)
  seconds <- round(time_diff_secs %% 60, 2)
  # Print the result in a formatted string
  return(paste(hours, "hours", minutes, "minutes", seconds, "seconds"))
}

