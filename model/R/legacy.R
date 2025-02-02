#' Get Score Mappings
#'
#' @param config `data.frame` The configuration file
#' @param persona `integer` The persona
#'
#' @returns A mapping {layer_name : {raster_value : persona_score}}
#'
#' @export
get_score_mappings <- function(config, persona) {
    # Add persona as a new column
    # TODO: this may need to be more robust and/or moved elsewhere
    config[["persona"]] <- persona

    # Group the config by dataset, i.e. by layer
    # Results in a mapping {layer_name : layer_config}
    config_by_layer <- split(config, as.factor(config[["Dataset"]]))

    # Generate a mapping {layer_name : {raster_value : persona_score}}
    mappings <- lapply(
        config_by_layer, function(layer_config) {
            setNames(layer_config[["persona"]], layer_config[["Raster_Val"]])
        }
    )
    return(mappings)
}

#' Reclassify a single-layered SpatRaster using a mapping
#'
#' @param spat_raster `SpatRaster` The SpatRaster to be reflassified
#' @param mapping `numeric` A mapping from current values to new values
#'
#' @export
reclassify_layer <- function(layer, mapping) {
    curr_values <- terra::values(layer)

    # TODO: fix this when data type issue resolved
    # See https://github.com/rspatial/terra/issues/1036
    if (!is.integer(curr_values)) {
        stop("Layer contains non-integer values.")
    }
    if (!is.integer(names(mapping))) {
        stop("Mapping keys contain non-integer values")
    }

    new_values <- mapping[curr_values]

    terra::values(layer) <- new_values

    return(layer)
}

#' Just loop over layers and reclassify
#'
#' @export
reclassify_raster <- function(raster, mappings) {
    for (layer_name in names(raster)) {
        # TODO: throw error if doesn't exist
        mapping <- mappings[[layer_name]]

        raster[[layer_name]] <- reclassify_layer(raster[[layer_name]], mapping)
    }
    return(raster)
}

#' Reclassify the slope raster
#' @export
reclassify_slopes <- function(raster, config) {
    slope_df <- data.frame(
        group_val_min = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
        group_val_max = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
        score = config[["persona"]]
    )
    raster <- terra::classify(raster, rcl = data.matrix(slope_df))
    return(raster)
}

#' Compute Recreational Potential
#'
#' @export
compute_potential <- function(crop_area, persona, data_dir) {
    # Up-front check that data_dir exists, is readable, contains required files
    .assert_valid_data_dir(data_dir)

    # Load global config
    config <- load_config()

    # Generate mappings { layer_name : { raster_value : persona_score } }
    mappings <- get_score_mappings(config, persona)

    slsra <- file.path(data_dir, "SLSRA.tif") |>
        load_raster(crop_area) |>
        to_int() |>
        reclassify_raster(mappings) |>
        na_to_zero() |>
        sum_layers() |>
        rescale_to_unit_interval()

    fips_n <- file.path(data_dir, "FIPS_N.tif") |>
        load_raster(crop_area) |>
        to_int() |>
        reclassify_raster(mappings)

    fips_n_slope <- file.path(data_dir, "FIPS_N_Slope.tif") |>
        load_raster(crop_area) |>
        reclassify_slopes(mappings) # NOTE: does this need mappings?

    fips_n <- c(fips_n, fips_n_slope) |>
        na_to_zero() |>
        sum_layers() |>
        rescale_to_unit_interval()

    fips_i <- file.path(data_dir, "FIPS_I.tif") |>
        load_raster(crop_area) |>
        to_int() |>
        reclassify_raster(mappings) |>
        na_to_zero()

    fips_i_proximity <- file.path(data_dir, "FIPS_I_Proximity.tif") |>
        load_raster(crop_area) |>
        logistic_func(alpha = 0.01101, kappa = 5)

    fips_i <- (fips_i_proximity * fips_i) |>
        sum_layers() |>
        rescale_to_unit_interval()

    water <- file.path(data_dir, "Water.tif") |>
        load_raster(crop_area) |>
        to_int() |>
        reclassify_raster(mappings) |>
        na_to_zero()

    water_proximity <- file.path(data_dir, "Water_Proximity.tif") |>
        load_raster(crop_area) |>
        logistic_func(alpha = 0.01101, kappa = 5)

    water <- (water_proximity * water) |>
        sum_layers() |>
        rescale_to_unit_interval()

    # Sum and rescale again
    # NOTE: for reducing memory, consider accumulating the master raster
    # step-by-step, and deleting the other objects from memory
    potential <- rescale_to_unit_interval(slsra + fips_n + fips_i + water)

    # NOTE: consider masking values outside AOI if non-rectangular

    return(potential)
}
