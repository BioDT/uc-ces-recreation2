# TODO: fix this shit
default_config <- here::here("config.csv")
# system.file("extdata", "config.csv", package = "model")

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
    loaded_config <- readr::read_csv(config_path, col_types = column_spec)

    return(loaded_config)
}

.read_persona_csv <- function(csv_path) {
    # Read csv as a dataframe of integers, throwing an error for non-integer elements
    df <- readr::read_csv(
        csv_path,
        col_types = readr::cols(
            index = readr::col_character(),
            .default = readr::col_integer()
        )
    )
    # NOTE: this may be redundant given index specified in col_types
    if (!"index" %in% colnames(df)) {
        stop("Error: the file does not contain an index column")
    }

    # Recast the "index" column as the index
    # Note we need to convert from tibble to data.frame
    df <- as.data.frame(df)
    rownames(df) <- df[["index"]]
    df[["index"]] <- NULL

    if (!ncol(df) > 0) {
        stop("Error: the file does not contain any personas")
    }

    return(df)
}

.assert_valid_persona <- function(persona) {
    expected_names <- load_config()[["Name"]]
    if (!identical(sort(names(persona)), sort(expected_names))) {
        stop("Error: malformed names in the persona vector")
    }
    if (!all(persona == floor(persona))) {
        stop("Error: persona contains non-integer values")
    }
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
#' @return `integer` A named vector of integers representing the persona
#'
#' @export
load_persona <- function(csv_path, name = NULL) {
    df <- .read_persona_csv(csv_path)

    if (is.null(name)) {
        if (ncol(df) > 1) {
            stop("Error: `name` is required when the persona file contains >1 persona")
        }
        # There is only one persona in the file
        persona_df <- df
    } else {
        # Select the column with the provided name
        persona_df <- df[, name, drop = FALSE]
    }

    stopifnot(ncol(persona_df) == 1)

    # Convert to named vector
    persona <- setNames(persona_df[[1]], rownames(persona_df))

    .assert_valid_persona(persona)

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
    .assert_valid_persona(persona)

    # Create a dataframe with 'index' and 'name'
    df <- data.frame(index = names(persona))
    df[[name]] <- persona

    if (file.exists(csv_path)) {
        message(paste0("File ", csv_path, " already exists. The persona will be appended."))

        # We need to merge the two dataframes carefully, using the named rows

        # This currently has 'rownames' but no 'index' column
        df_a <- .read_persona_csv(csv_path)

        # We need to set rownames to align the two during the merge
        df_b <- df
        rownames(df_b) <- df_b[["index"]]

        # Delete the 'index' column since we cannot guarantee ordering after merge
        # so we need to re-create it from the merged dataframes rownames
        df_b[["index"]] <- NULL

        # Check if we are overwriting an existing persona and delete the column if so
        # since otherwise we end up with `name1` and `name2` or something like that
        if (name %in% colnames(df_a)) {
            message(paste0("A persona with name ", name, " already exists, and will be overwritten")) # nolint
            df_a[[name]] <- NULL
        }

        # Finally, merge the two dataframes
        df <- cbind(df_a, df_b)

        # Order by index and restore explicit index column at position 1
        df <- df[order(rownames(df)), , drop = FALSE]
        df[["index"]] <- rownames(df)
        df <- df[, c("index", setdiff(colnames(df), "index"))]
    }

    message(paste0("Writing persona to file ", csv_path))
    readr::write_csv(df, csv_path)
}
