library(dplyr)
# Step 1: parse args
# * persona_file_path
# * bounding box ...?

# Step 2: load stuff

# Load global config
config <- load_config()

# Load persona
persona <- load_persona(persona_file_path)

# TODO: add persona as a column to config

# TODO: this could be a shapefile, but even better would be just a xmin, xmax, ymin, ymax
crop_area <- ...

# Lazily load rasters, cropped to area of interest
slsra <- load_raster(slsra_path, crop_area)
fips_n <- load_raster(fips_n_path, crop_area)
fips_n_slope <- load_raster(fips_n_slope_path, crop_area)
fips_i <- load_raster(fips_i_path, crop_area)
water <- load_raster(water_path, crop_area)

combined_rasters <- c(slsra, fips_n, fips_i, water)

# Step 3: Reclassify rasters?
config_by_dataset <- group_by_mapping(config, by = Dataset)

# Assert that the set of unique values for 'Dataset' in the config
# is equal to the set of layer names for the combined rasters.
stopifnot(setequal(names(combined_rasters), names(config_by_dataset)))

# NOTE: man I miss `zip` in python
for (layer_name in names(combined_rasters)) {
    # Pull out the raster layer and the config
    layer <- combined_rasters[[layer_name]]
    layer_config <- config_by_dataset[[layer_name]]

    # Mapping from old to new values (new being defined in persona)
    mapping <- setNames(layer_config$persona, layer_config$Raster_Vals)

    # Reclassify, i.e. replace old values with new
    layer <- reclassify_raster(layer, mapping)
}
