library(dplyr)
library(terra)


# NOTE: {{ by }} means `by` should be passed without quotes, as though
# the function was a standard dplyr one with non-standard evaluation
# le crie

group_by_mapping <- function(df, by) {
    values <- df |>
        group_by({{ by }}) |>
        group_split()

    keys <- df |>
        group_by({{ by }}) |>
        group_keys() |>
        pull({{ by }})

    mapping <- setNames(values, keys)

    return(mapping)
}

#' Reclassify a SpatRaster based on a lookup table
#'
#' @param spat_raster `SpatRaster` The SpatRaster to be reflassified
#' @param mapping `numeric` A _named_ vector mapping current values (names) to new (values)
reclassify_raster <- function(spat_raster, mapping) {
    curr_values <- terra::values(spat_raster)

    new_values <- mapping[curr_values]

    # NOTE: original code set NA to 0, but I'm not sure this is necessary/good
    # new_values[is.na(new_values)] <- 0

    terra::values(spat_raster) <- new_values

    return(spat_raster)
}
