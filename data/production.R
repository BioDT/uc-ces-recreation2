library(terra)

devtools::load_all("../model")

config <- model::load_config()
feature_mappings <- get_feature_mappings(config)

input_data_dir <- "DataLabs"
output_data_dir <- "Processed"

# Generate a mapping { layer : file_path }
file_paths <- lapply(
    list.files(path = input_data_dir, pattern = "\\.tif$", recursive = TRUE),
    function(file_) file.path(input_data_dir, file_)
)
file_stems <- lapply(
    file_paths,
    function(path) tools::file_path_sans_ext(basename(path))
)
files <- setNames(file_paths, file_stems)
stopifnot(all(names(feature_mappings) %in% names(files)))

reference_raster <- rast(
    crs = "EPSG:27700",
    res = c(20, 20),
    ext = ext(-10000, 660000, 460000, 1220000) # xmin, xmax, ymin, ymax
)

# First need to quantise the slope values before one-hot encoding
# NOTE: I do not know the origin of these intervals
slope_rcl <- data.matrix(data.frame(
    lower_bound = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
    upper_bound = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
    mapped_to = c(1, 2, 3, 4, 5, 6)
))

# ---------------------------------
# Convert to one-hot representation
# ---------------------------------
for (layer_name in names(feature_mappings)) {
    message(paste("Converting", layer_name, "to one-hot representation"))
    start_time <- Sys.time()

    infile <- files[[layer_name]]
    feature_mapping <- feature_mappings[[layer_name]]

    # Match the directory structure within data_dir, but remove data_dir
    outfile <- sub("^[^/]+", output_data_dir, infile)

    message(paste("Reading from", infile, "; Writing to", outfile))

    # Create directory if it doesn't already exist
    dir.create(dirname(outfile), recursive = TRUE, showWarnings = FALSE)

    if (layer_name == "FIPS_N_Slope") {
        layer <- rast(infile) |> classify(rcl = slope_rcl)
    } else {
        layer <- rast(infile)
    }

    if (layer_name == "Water_Rivers") {
        layer |>
            round() |>
            categorical_to_one_hot(feature_mapping) |>
            project(reference_raster) |>
            round() |>
            writeRaster(outfile)
    }

    end_time <- Sys.time()
    message(paste(layer_name, "took", end_time - start_time, "to complete"))
}

rm(layer)
gc()

stop()

# ----------------------------------------------
# Create four stacked rasters for each component
# ----------------------------------------------
for (component in c("SLSRA", "FIPS_N", "FIPS_I", "Water")) {
    outfile <- file.path(output_data_dir, paste0(component, ".tif"))
    message(paste("Stacking component", component, "and writing to", outfile))

    file_paths <- lapply(
        list.files(
            path = file.path(output_data_dir, component),
            pattern = "\\.tif$",
            recursive = TRUE
        ),
        function(file_) file.path(output_data_dir, component, file_)
    )

    stacked <- rast(lapply(file_paths, rast))

    writeRaster(stacked, outfile)
}
