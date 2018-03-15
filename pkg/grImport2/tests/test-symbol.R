library(grid)
library(grImport2)
library(gridSVG)

pic <- readPicture("test-symbol-input.svg")

gridsvg("test-symbol-output.svg", width = 6, height = 6, annotate = FALSE)
grid.picture(pic, expansion = 0)
dev.off()

if (! all(readLines("test-symbol-output.svg") ==
          readLines("test-symbol-output.svg.save")))
    stop("symbol/use output not equal to expected output")

