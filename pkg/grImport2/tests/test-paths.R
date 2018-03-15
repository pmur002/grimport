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

## Encoding in SVG file (on line 1) differs by platform
if (! all(readLines("test-path-simple-output.svg")[-1] ==
          readLines("test-path-simple-output.svg.save")[-1]))
    stop("simplepath expected not equal to expected output")

if (! all(readLines("test-path-complex-output.svg")[-1] ==
          readLines("test-path-complex-output.svg.save")[-1]))
    stop("complexpath output not equal to expected output")

