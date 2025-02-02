library(testthat)

# TODO: import package instead of directly sourcing
source("../../R/config.R")

test_that("fail gracefully for misconfigured persona file", {
    test_file <- tempfile(fileext = ".csv")

    persona_nonames <- sample(0:10, size = 87, replace = TRUE)

    # readr::write_csv(test_file, persons_nonames)

    # TODO:
    # load_persona(test_file)
    unlink(test_file)
})



# Test that a single persona can be saved and re-loaded
test_that("saving and loading a single persona", {
    test_file <- tempfile(fileext = ".csv")

    config <- load_config()
    persona <- setNames(
        sample(0:10, size = 87, replace = TRUE),
        config[["Name"]]
    )

    save_persona(persona, test_file, "persona")

    expect_true(file.exists(test_file))

    loaded_persona <- load_persona(test_file)

    expect_equal(loaded_persona, persona)

    unlink(test_file)
})

test_that("appending a person", {
    test_file <- tempfile(fileext = ".csv")

    config <- load_config()
    persona1 <- setNames(
        sample(0:10, size = 87, replace = TRUE),
        config[["Name"]]
    )
    persona2 <- setNames(
        sample(0:10, size = 87, replace = TRUE),
        config[["Name"]]
    )

    save_persona(persona1, test_file, "persona1")
    save_persona(persona2, test_file, "persona2")
})

# TODO:
# 1. Test multiple persona in a single file
# 2. Test that overwriting an existing persona works
