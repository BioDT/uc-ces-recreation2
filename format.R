# Run from terminal as `Rscript format.R`

library(here)
library(formatR)

setwd(here::here())

# Skip UI_Functions because formatR does not format these nicely
formatR::tidy_dir(
  path="Functions",
  recursive=TRUE,
  comment=TRUE,
  blank=TRUE,
  arrow=TRUE,
  pipe=FALSE,
  brace.newline=FALSE,
  indent=4,
  wrap=FALSE,
  width.cutoff=80,
  args.newline=TRUE,
)

