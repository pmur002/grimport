library(grid)
library(grImport2)
library(gridSVG)

pic <- readPicture("test-symbol-input.svg")

gridsvg("test-symbol-output.svg", width = 6, height = 6, annotate = FALSE)
grid.picture(pic, expansion = 0)
dev.off()

## Encoding in SVG file (on line 1) differs by platform
if (! all(readLines("test-symbol-output.svg")[-1] ==
          readLines("test-symbol-output.svg.save")[-1]))
    stop("symbol/use output not equal to expected output")

