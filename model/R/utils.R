#' Generate Score Mappings
#'
#' @export
generate_mappings <- function(config, persona) {
    # TODO: produce a list of current_raster_val: score mappings
}

# NOTE: {{ by }} means `by` should be passed without quotes, as though
# the function was a standard dplyr one with non-standard evaluation
# le crie

group_by_mapping <- function(df, by) {
    values <- df |>
        dplyr::group_by({{ by }}) |>
        dplyr::group_split()

    keys <- df |>
        dplyr::group_by({{ by }}) |>
        dplyr::group_keys() |>
        dplyr::pull({{ by }})

    mapping <- setNames(values, keys)

    return(mapping)
}

#' Reclassify a SpatRaster based on a lookup table
#'
#' @param spat_raster `SpatRaster` The SpatRaster to be reflassified
#' @param mapping `numeric` A _named_ vector mapping current values (names) to new (values)
#'
#' @export
reclassify <- function(spat_raster, mapping) {
    curr_values <- terra::values(spat_raster)

    new_values <- mapping[curr_values]

    # NOTE: original code set NA to 0, but I'm not sure this is necessary/good
    new_values[is.na(new_values)] <- 0

    terra::values(spat_raster) <- new_values

    return(spat_raster)
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
