#' Compute Recreational Potential
#'
#' @export
compute_potential <- function(crop_area, persona, data_dir, config_path = NULL) {
    # Up-front check that data_dir exists, is readable, contains required files
    # assert_valid_data_dir(data_dir)

    # Load global config
    config <- load_config(config_path)

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
