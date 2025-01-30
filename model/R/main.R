slsra_raster_path <- system.file("data", "slsra.tif", package = "model")
fips_n_raster_path <- system.file("data", "fips_n.tif", package = "model")
fips_n_slope_raster_path <- system.file("data", "fips_n_slope.tif", package = "model")
fips_i_raster_path <- system.file("data", "fips_i.tif", package = "model")
fips_i_proximity_raster_path <- system.file("data", "fips_i_proximity.tif", package = "model")
water_raster_path <- system.file("data", "water.tif", package = "model")
water_proximity_raster_path <- system.file("data", "water_proximity.tif", package = "model")

#' Compute Recreational Potential
#'
#' @export
compute_potential <- function(crop_area, persona) {
    # Load global config
    config <- load_config()

    mappings <- generate_mappings(config, persona)
    slsra_scores <- mappings[[1]]
    fips_n_scores <- mappings[[2]]
    fips_n_slope_scores <- mappings[[3]]
    fips_i_scores <- mappings[[4]]
    water_scores <- mappings[[3]]

    slsra <- slsra_raster_path |>
        load_raster(crop_area) |>
        reclassify(slsra_scores) |>
        sum_layers() |>
        rescale_to_unit_interval()

    fips_n <- fips_n_raster_path |>
        load_raster(crop_area) |>
        reclassify(fips_n_scores)

    fips_n_slope <- fips_n_slope_raster_path |>
        load_raster(crop_area) |>
        reclassify_slopes(fips_n_slope_scores)

    fips_n <- c(fips_n, fips_n_slope) |>
        sum_layers() |>
        rescale_to_unit_interval()

    fips_i <- fips_i_raster_path |>
        load_raster(crop_area) |>
        reclassify(fips_i_scores)

    fips_i_proximity <- fips_i_proximity_raster_path |>
        load_raster(crop_area) |>
        logistic_func()

    fips_i <- (fips_i_proximity * fips_i) |>
        sum_layers() |>
        rescale_to_unit_interval()

    water <- water_raster_path |>
        load_raster(crop_area) |>
        reclassify(water_scores)

    water_proximity <- water_proximity_raster_path |>
        load_raster(crop_area) |>
        logistic_func()

    water <- (water_proximity * water) |>
        sum_layers() |>
        rescale_to_unit_interval()

    # Sum and rescale again
    # NOTE: for reducing memory, consider accumulating the master raster
    # step-by-step, and deleting the other objects from memory
    master_raster <- rescale_to_unit_interval(slsra + fips_n + fips_i + water)

    return(master_raster)
}
