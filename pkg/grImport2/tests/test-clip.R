library(grid)
library(grImport2)
library(gridSVG)

pic <- readPicture("test-clip-input.svg")

gridsvg("test-noclip-output.svg", width = 6, height = 6, annotate=FALSE)
grid.picture(pic, expansion = 0)
dev.off()

gridsvg("test-bboxclip-output.svg", width = 6, height = 6, annotate=FALSE)
grid.picture(pic, expansion = 0, ext="clipbbox")
dev.off()

if (! all(readLines("test-noclip-output.svg") ==
          readLines("test-noclip-output.svg.save")))
    stop("noclip output not equal to expected output")

if (! all(readLines("test-bboxclip-output.svg") ==
          readLines("test-bboxclip-output.svg.save")))
    stop("bboxclip output not equal to expected output")

