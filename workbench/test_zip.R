library(readr)
library(dplyr)

library(model)

# TODO: import package instead of directly sourcing

slsra <- load_raster("../Data/input/Processed_Data/SLSRA.tif", "../Data/input/Raw_Shapefile/Bush/Bush.shp")
fips_n <- load_raster("../Data/input/Processed_Data/FIPS_N.tif", "../Data/input/Raw_Shapefile/Bush/Bush.shp")
fips_n_slope <- load_raster("../Data/input/Processed_Data/FIPS_N_Slope.tif", "../Data/input/Raw_Shapefile/Bush/Bush.shp")
fips_i <- load_raster("../Data/input/Processed_Data/FIPS_I.tif", "../Data/input/Raw_Shapefile/Bush/Bush.shp")
water <- load_raster("../Data/input/Processed_Data/Water.tif", "../Data/input/Raw_Shapefile/Bush/Bush.shp")
combined <- c(slsra, fips_n, fips_n_slope, fips_i, water)

print(names(combined))

config <- load_config()

config_by_layer <- config |>
    group_by(Dataset) |>
    group_split()

layer_names <- config |>
    group_by(Dataset) |>
    group_keys() |>
    pull(Dataset)

config_lookup <- setNames(config_by_layer, layer_names)

print(layer_names)

stopifnot(setequal(names(combined), names(config_lookup)))

print("dogs")
