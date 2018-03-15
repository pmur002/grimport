library(grid)
library(grImport2)
library(gridSVG)

pic <- readPicture("test-rect-input.svg")

gridsvg("test-rect-output.svg", width = 6, height = 6, annotate = FALSE)
grid.picture(pic, expansion = 0)
dev.off()

if (! all(readLines("test-rect-output.svg") ==
          readLines("test-rect-output.svg.save")))
    stop("rect output not equal to expected output")

