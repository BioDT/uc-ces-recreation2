# default_config <- system.file("extdata", "config.csv", package = "model")
default_config <- "../inst/extdata/config.csv"

#' Load configuration from file
#'
#' @param config_path `character` Optional path to non-default configuration file
#'
#' @export
load_config <- function(config_path = NULL) {
    if (is.null(config_path)) {
        config_path <- default_config
    }

    column_spec <- readr::cols(
        Component = readr::col_character(),
        Dataset = readr::col_character(),
        Name = readr::col_character(),
        Description = readr::col_character(),
        Raster_Val = readr::col_integer()
    )

    # Load config, type casting each column
    loaded_config <- readr::read_csv(config_path, col_types = column_spec)

    # TODO: check num rows, no additional cols

    return(loaded_config)
}

.validate_persona <- function(persona) {
    # TODO:
    # * Check length ?
    # * Check all integers between 0 and 10?
    return()
}

#' Load Persona
#'
#' Loads a single persona from a csv file containing one or more personas.
#' If the file contains more than one persona (i.e. columns), a name specifying
#' which personal (column) to load must also be provided.
#'
#' @param csv_path `character` Path to a csv file containing one or more personas
#' @param name `character` Name of the persona, which should match a column name
#'
#' @return `integer` A vector of integers representing the persona
#'
#' @export
load_persona <- function(csv_path, name = NULL) {
    loaded_csv <- readr::read_csv(csv_path)

    if (ncol(loaded_csv) == 0) {
        stop("Error: the persona file is empty")
    }

    if (is.null(name)) {
        if (ncol(loaded_csv) > 1) {
            stop("Error: `name` is required when the persona file contains >1 persona")
        }
        # Use the first and only column in the file
        persona <- loaded_csv[[1]]
    } else {
        # Load persona from the column with the provided name
        persona <- loaded_csv[[name]]
    }

    # All values should be integers anyway, so let's cast the type
    persona <- as.integer(persona)

    # TODO: should we attach this to the contents of `config.csv` as a dataframe?

    return(persona)
}

#' Save Persona
#'
#' Saves a persona to a csv file. If the csv file already exists, the persona
#' will be appended as a new column, unless the provided name matches an existing
#' column, in which case it will overwrite the existing data.
#'
#' @param persona `integer` A vector of integers representing the persona
#' @param csv_path `character` Path to write a csv file, which may already exist
#' @param name `character` Name of the persona
#'
#' @export
save_persona <- function(persona, csv_path, name) {
    if (file.exists(csv_path)) {
        message(paste0("'File '", csv_path, "' exists. The persona will be appended."))
        df <- readr::read_csv(csv_path)

        # NOTE: should we throw a warning or error for overwriting an existing col?
        df[[name]] <- persona
    } else {
        # Create a new single-column dataframe
        df <- data.frame(persona)
        names(df) <- name
    }

    message(paste0("'Writing persona to file '", csv_path, "' under name '", name))
    readr::write_csv(df, csv_path)
}


#' Load a cropped raster
#'
#' @description
#' Load a cropped raster from a file
#'
#' @details
#' Details...
#'
#' @param raster_path `character` Path to a raster file to load
#' @param crop_area A SpatExtent or another object with a SpatExtent
#'
#' @examples
#' load_raster("path/to/raster.tif", terra::vect("path/to/shapefile.shp"))
#' load_raster("path/to.raster.tif", terra::ext(xmin, xmax, ymin, ymax))
#'
#' @export
load_raster <- function(raster_path, crop_area) {
    # Lazy load raster from file
    raster <- terra::rast(raster_path)

    # Crop using either a shapefile or SpatExtent
    raster <- terra::crop(raster, crop_area)

    # If crop_area is a vector we also need to mask, since
    # terra::crop only restricts to the bounding box of the vector
    if (inherits(crop_area, "SpatVector")) {
        raster <- terra::mask(raster, crop_area)
    }

    return(raster)
}
