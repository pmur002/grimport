readPicture <- function(file) {
    if (missing(file))
        stop("'file' must be a character string representing a path to a file.")
    svgImage <- xmlRoot(xmlParse(file))
    pictureDims <- getPictureDims(svgImage)
    # Need to create picture definitions table first
    picdefs <- parsePictureDefinitions(svgImage)
    # Now parse the contents of the image (<defs> are ignored).
    # <use>s are resolved to "real" elements
    pic <- parseImage(xmlChildren(svgImage, addNames = FALSE),
                      picdefs, createDefs = FALSE)
    new("Picture",
        content = pic,
        defs = picdefs,
        summary = new("PictureSummary",
                      xscale = c(0, pictureDims[1]),
                      yscale = c(pictureDims[2], 0)))
}
