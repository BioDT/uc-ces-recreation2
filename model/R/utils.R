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


#' Convert raster to int
#'
#' @export
to_int <- function(raster, tol = 1e-5) {
    # NOTE: see https://github.com/rspatial/terra/issues/763 for why
    # SpatRasters may be double-typed even when .tif is integer-typed

    values <- terra::values(raster)
    rounded_values <- round(values)

    # Throw an error if any values are further than 'tol' from the nearest int
    if (any(abs(values - rounded_values) > tol)) {
        stop("Raster contains non-integer values")
    }

    terra::values(raster) <- rounded_values

    return(raster)
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


#' NA to zero
#'
#' Map NA (not available / missing) to zero, keeping NaN as is
#'
#' @export
na_to_zero <- function(raster) {
    return(terra::ifel(is.na(raster) & !is.nan(raster), 0, raster))
}

#' Sum the layers of a SpatRaster
#'
#' @export
sum_layers <- function(raster) {
    return(terra::app(raster, sum))
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


#' Compute a logistic function
#'
#' @param x A raster
#' @param alpha Coefficient in the exponent
#' @param kappa A less important parameter
#'
#' @export
logistic_func <- function(x, alpha, kappa) {
    # TODO: add link to paper, equation etc.
    return((kappa + 1) / (kappa + exp(alpha * x)))
}
