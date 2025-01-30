library(testthat)

# TODO: import package instead of directly sourcing
source("../../R/io.R")

# Test that a single persona can be saved and re-loaded
test_that("saving and loading a single persona", {
    test_file <- tempfile(fileext = ".csv")

    original_persona <- c(1, 2, 3, 4, 5) # TODO: a real persona
    save_persona(original_persona, test_file, "name")

    loaded_persona <- load_persona(test_file)

    expect_true(file.exists(test_file))
    expect_equal(loaded_persona, original_persona)

    unlink(test_file)
})

# TODO:
# 1. Test multiple persona in a single file
# 2. Test that overwriting an existing persona works
