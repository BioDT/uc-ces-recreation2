# NOTE: abandon the following: use terra instead of sf

# Read shapefile
# shapefile <- sf::st_read(shapefile_path)

# Drop the Z (elevation) dimension if present
# shapefile <- sf::stzm(shapefile, drop = TRUE, what = "ZM")

# Transform to WGS84 (EPSG 4326)
# crs <- sf::st_crs(shapefile)$epsg
# if (is.na(crs) || crs != 4326) {
# sf::st_transform(shapefile, crs = 4326)
# }



# -----------------------------------------------------------------------------------------
# config_by_dataset <- group_by_mapping(config, by = Dataset)

# Assert that the set of unique values for 'Dataset' in the config
# is equal to the set of layer names for the combined rasters.
# stopifnot(setequal(names(combined_rasters), names(config_by_dataset)))

# for (layer_name in names(combined_rasters)) {
# Pull out the raster layer and the config
# layer <- combined_rasters[[layer_name]]
# layer_config <- config_by_dataset[[layer_name]]

# Mapping from old to new values (new being defined in persona)
# mapping <- setNames(layer_config$persona, layer_config$Raster_Vals)

# Reclassify, i.e. replace old values with new
# layer <- reclassify_raster(layer, mapping)
# }
