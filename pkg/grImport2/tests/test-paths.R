library(grid)
library(grImport2)
library(gridSVG)

pic <- readPicture("test-path-simple-input.svg")

gridsvg("test-path-simple-output.svg", width = 6, height = 6, annotate = FALSE)
grid.picture(pic, expansion = 0)
dev.off()

pic <- readPicture("test-path-complex-input.svg")

gridsvg("test-path-complex-output.svg", width = 6, height = 6, annotate = FALSE)
grid.picture(pic, expansion = 0)
dev.off()

if (! all(readLines("test-path-simple-output.svg") ==
          readLines("test-path-simple-output.svg.save")))
    stop("simplepath expected not equal to expected output")

if (! all(readLines("test-path-complex-output.svg") ==
          readLines("test-path-complex-output.svg.save")))
    stop("complexpath output not equal to expected output")

