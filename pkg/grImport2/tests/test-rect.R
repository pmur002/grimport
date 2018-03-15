library(grid)
library(grImport2)
library(gridSVG)

pic <- readPicture("test-rect-input.svg")

gridsvg("test-rect-output.svg", width = 6, height = 6, annotate = FALSE)
grid.picture(pic, expansion = 0)
dev.off()

## Encoding in SVG file (on line 1) differs by platform
if (! all(readLines("test-rect-output.svg")[-1] ==
          readLines("test-rect-output.svg.save")[-1]))
    stop("rect output not equal to expected output")

