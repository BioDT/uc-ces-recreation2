process_area_of_interest <- function(Raw_Shapefile, Boundary_name, input_folder, resolution = 20, max_distance = 1500) {
  # Find shapefiles in the directory that include the text in Boundary_name, case-insensitive
  shapefiles <- list.files(
    path = Raw_Shapefile, 
    pattern = paste0(".*", Boundary_name, ".*\\.shp$"), 
    full.names = TRUE,
    ignore.case = TRUE
  )
  
  if (length(shapefiles) == 0) {
    stop("No shapefiles found with the specified Boundary_name.")
  }
  
  # Read the first shapefile found
  shapefile <- st_read(shapefiles[1])
  # Convert to EPSG:27700
  shapefile_27700 <- st_transform(shapefile, crs = "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +datum=OSGB36 +units=m +no_defs", SHPT='POLYGON')
  # Convert 3D shapefile to 2D
  shapefile_27700 <- st_zm(shapefile_27700, drop = TRUE, what = "ZM")
  # Remove all existing fields (keep only the geometry)
  shapefile_27700 <- shapefile_27700[ , "geometry"]
  # Create a new numeric field (ID)
  shapefile_27700$id <- 1  # Assigning a constant value for simplicity
  
  # Check if the shapefile exists
  if (file.exists(file.path(input_folder, "boundaries.shp"))) {
    # Delete the existing shapefile
    file.remove(file.path(input_folder, "boundaries.shp"))
  }
  # Save the converted shapefile, overwriting existing files
  st_write(shapefile_27700, file.path(input_folder, "boundaries.shp"), overwrite = TRUE)
  
  # Ensure the field to be rasterized is numeric. For example, if you want to rasterize an "ID" field:
  # If the field is not numeric, convert it to numeric (create a new field if necessary)
  shapefile_27700$id <- as.numeric(shapefile_27700$id)
  
  # Create an empty raster using the extent and CRS of the shapefile
  ext <- raster::extent(st_bbox(shapefile_27700))
  crs <- st_crs(shapefile_27700)$proj4string
  empty_raster <- raster(ext, res = resolution, crs = crs)
  
  # Rasterize the shapefile using the numeric field
  rasterized <- rasterize(shapefile_27700, empty_raster, field = "id")
  
  # Save the rasterized shapefile
  writeRaster(rasterized, file.path(input_folder, "empty.tif"), format = "GTiff", overwrite = TRUE)
  
  # Load the rasterized shapefile as Raster_Empty
  Raster_Empty <- raster(file.path(input_folder, "empty.tif"))
  values(Raster_Empty) <- 0
  
  # Load the boundaries shapefile as mask_boundary
  target_shapefile <- file.path(input_folder, "boundaries.shp")
  mask_boundary <- st_read(target_shapefile)
  
  return(list(Raster_Empty = Raster_Empty, mask_boundary = mask_boundary))
}