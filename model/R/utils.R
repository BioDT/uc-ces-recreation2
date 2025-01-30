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



# NOTE: consider renaming reclassify -> remap

#' Reclassify a single-layered SpatRaster using a mapping
#'
#' @param spat_raster `SpatRaster` The SpatRaster to be reflassified
#' @param mapping `numeric` A mapping from current values to new values
#'
#' @export
reclassify_layer <- function(layer, mapping) {
    curr_values <- terra::values(layer)

    # TODO: fix this when data type issue resolved

    # TODO: use typof rather than testing all values equal
    # Check that we are working with integers, as we should
    if (!all(curr_values == as.integer(curr_values), na.rm = TRUE)) {
        stop("Layer contains non-integer values.")
    }
    #   if (!is.integer(names(mapping))

    new_values <- mapping[curr_values]

    # NOTE: original code set NA to 0, but I'm not sure this is necessary/good
    # new_values[is.na(new_values)] <- 0

    terra::values(layer) <- new_values

    return(layer)
}

# Just loop over layers and reclassify
reclassify_raster <- function(raster, mappings) {
    for (layer_name in names(raster)) {
        # TODO: throw error if doesn't exist
        mapping <- mappings[[layer_name]]

        raster[[layer_name]] <- reclassify_layer(raster[[layer_name]], mapping)
    }
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

#' Rescale a SpatRaster to [0, 1]
#'
#' @export
rescale_to_unit_interval <- function(raster) {
    min_value <- min(terra::values(raster), na.rm = TRUE)
    max_value <- max(terra::values(raster), na.rm = TRUE)

    result <- (raster - min_value) / (max_value - min_value)

    return(result)
}

#' Sum the layers of a SpatRaster
#' @export
sum_layers <- function(raster) {
    return(terra::app(raster, sum))
}


#' Compute a logistic function
#'
#' @param x A raster
#' @param alpha Coefficient in the exponent
#' @param kappa A less important parameter
#'
#' @export
logistic_func <- function(x, alpha = 0.01101, kappa = 5) {
    # TODO: add link to paper, equation etc.
    return((kappa + 1) / (kappa + exp(alpha * x)))
}
