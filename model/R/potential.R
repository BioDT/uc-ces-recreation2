#' Compute a single component
#'
#' @export
compute_component <- function(raster, persona) {
    scores <- persona[names(raster)]
    result <- terra::app(raster, function(features) {
        sum(scores * features, na.rm = TRUE)
    })
    return(result)
}

#' Compute Recreational Potential
#'
#' @export
compute_potential <- function(persona, raster_dir, bbox = NULL) {
    # Up-front check that raster_dir exists, is readable, contains required files
    .assert_valid_raster_dir(raster_dir)

    slsra <- file.path(raster_dir, "SLSRA.tif") |>
        load_raster(bbox) |>
        compute_component(persona)

    fips_n <- file.path(raster_dir, "FIPS_N.tif") |>
        load_raster(bbox) |>
        compute_component(persona)

    fips_i <- file.path(raster_dir, "FIPS_I.tif") |>
        load_raster(bbox) |>
        compute_component(persona)

    water <- file.path(raster_dir, "Water.tif") |>
        load_raster(bbox) |>
        compute_component(persona)

    # Sum and rescale
    potential <- rescale_to_unit_interval(slsra + fips_n + fips_i + water)

    stacked <- c(slsra, fips_n, fips_i, water, potential)
    names(stacked) <- c("SLSRA", "FIPS_N", "FIPS_I", "Water", "Recreational_Potential")

    return(stacked)
}
