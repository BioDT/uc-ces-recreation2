testthat::test_dir("tests/testthat")

style <- styler::tidyverse_style(
    indent_by = 4L,
    start_comments_with_one_space = TRUE
)

# TODO: apply to the entire package
styler::style_file(
    "R/io.R",
    transformers = style
)

lintr::lint("R/io.R")
