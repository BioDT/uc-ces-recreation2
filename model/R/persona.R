library(readr)


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
    loaded_csv <- read.csv(csv_path)

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
        df <- read_csv(csv_path)

        # NOTE: should we throw a warning or error for overwriting an existing col?
        df[[name]] <- persona
    } else {
        # Create a new single-column dataframe
        df <- data.frame(persona)
        names(df) <- name
    }

    message(paste0("'Writing persona to file '", csv_path, "' under name '", name))
    write_csv(df, csv_path)
}
