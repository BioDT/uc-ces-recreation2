#' Calculate Euclidean Distance
#'
#' This functions computes the Euclidean distance ???
#'
#' @param proximity_rasters A list of rasters
#' @param alpha ?
#' @param kappa ?
#' @return A list of rasters
#' @export
calculate_euclidean_distance <- function(proximity_rasters, alpha = 0.01101, kappa = 5) {
    # Create an empty list to store the output rasters
    euc_dist_rasters <- list()

    # Loop over the proximity rasters
    for (score in names(proximity_rasters)) {
        euc_dist_rasters[[score]] <- ((kappa + 1) / (kappa + exp(proximity_rasters[[score]] * alpha))) *
            as.numeric(score)
    }

    terra_rasters <- terra::rast(euc_dist_rasters)

    # Return the output rasters
    return(terra_rasters)
}
