pictureGrob <- function(picture, 
                        x = unit(0.5, "npc"), y = unit(0.5, "npc"),
                        width = NULL, height = NULL,
                        just = "centre", hjust = NULL, vjust = NULL,
                        default.units = "npc",
                        expansion = 0.05, xscale = NULL, yscale = NULL,
                        distort = FALSE,
                        gpFUN = identity, ...,
                        ext = c("none", "clipbbox", "gridSVG"),
                        delayContent = match.arg(ext) == "gridSVG",
                        name = NULL, prefix = NULL, clip = "on") {
    if (!is.unit(x))
        x <- unit(x, default.units)
    if (!is.unit(y))
        y <- unit(y, default.units)
    if (!is.null(width) && !is.unit(width))
        width <- unit(width, default.units)
    if (!is.null(height) && !is.unit(height))
        height <- unit(height, default.units)
    if (delayContent) {
        gTree(picture=picture, 
              x = x, y = y, width = width, height = height,
              just = just, hjust = hjust, vjust = vjust,
              expansion = expansion, xscale = xscale, yscale = yscale,
              distort = distort, gpFUN = gpFUN, ext = match.arg(ext),
              clip = clip, prefix = prefix,
              grobifyArgs <- list(...),
              name = name, cl="PictureGrob")
    } else {
        if (is.null(prefix))
            prefix <- generateNewPrefix()
        setPrefix(prefix)
        grobify(picture, 
                x = x, y = y,
                width = width, height = height,
                default.units = default.units,
                just = just, hjust = hjust, vjust = vjust,
                expansion = expansion,
                xscale = xscale, yscale = yscale,
                distort = distort, gpFUN = gpFUN, ext = match.arg(ext),
                clip = clip, ..., name = name)
    }
}

makeContent.PictureGrob <- function(x, ...) {
    if (is.null(x$prefix))
        prefix <- generateNewPrefix()
    else
        prefix <- x$prefix
    setPrefix(prefix)
    picGrob <- do.call(grobify,
                       c(list(x$picture, 
                              x = x$x, y = x$y,
                              width = x$width, height = x$height,
                              just = x$just, hjust = x$hjust, vjust = x$vjust,
                              expansion = x$expansion,
                              xscale = x$xscale, yscale = x$yscale,
                              distort = x$distort, gpFUN = x$gpFUN, ext = x$ext,
                              clip = x$clip),
                         x$grobifyArgs))
    setChildren(x, gList(picGrob))
}

grid.picture <- function(...) {
    grid.draw(pictureGrob(...))
}

symbolsGrob <- function(picture,
                        x = stats::runif(10),
                        y = stats::runif(10),
                        size = unit(1, "char"),
                        default.units = "native",
                        gpFUN = identity,
                        ext = c("none", "clipbbox", "gridSVG"),
                        prefix = NULL,
                        ...,
                        name = NULL) {
    # Boilerplate for units, ensure that they are vectorised
    # and indeed proper grid units
    if (! is.unit(x))
        x <- unit(x, default.units)
    if (! is.unit(y))
        y <- unit(y, default.units)
    if (! is.unit(size))
        size <- unit(size, default.units)
    npics <- max(length(x), length(y), length(size))
    x <- rep(x, length.out = npics)
    y <- rep(y, length.out = npics)
    size <- rep(size, length.out = npics)

    ext <- match.arg(ext)

    # If we have gridSVG, then there is a fast way of drawing everything.
    # Simply draw a bunch of rectangles and fill them with a pattern.
    # The pattern definition is the picture itself.
    if (ext == "gridSVG") {
        if (! requireNamespace("gridSVG"))
            stop("gridSVG must be installed to use the 'gridSVG' extension")
        if (is.null(prefix))
            prefix <- generateNewPrefix()
        widths <- heights <- size
        rg <- rectGrob(x = x, y = y, width = widths, height = heights,
                       default.units = default.units, name = name,
                       gp = gpar(col = "#FFFFFF00", fill = "#FFFFFF00"))
        picdef <- pictureGrob(picture, gpFUN = gpFUN, expansion = 0,
                              ext = "gridSVG", prefix = prefix, ...)
        # Register the "base" pattern that we will later reference.
        # This ensures that only one definition is ever "drawn", the rest
        # are just referring to the definition and changing where it is
        # being used.
        gridSVG::registerPatternFill(prefix, gridSVG::pattern(picdef,
                                            width = 1, height = 1,
                                            just = c("left", "bottom")))
        for (i in seq_len(npics))
            gridSVG::registerPatternFillRef(paste0(prefix, ".", i), prefix,
                                   x = x[i], y = y[i],
                                   width = widths[i], height = heights[i])
        # Because we have registered all of the pattern fill references
        # we can apply them as a vector of labels (for group = FALSE)
        gridSVG::patternFillGrob(rg,
                        label = paste0(prefix, ".", seq_len(npics)),
                        group = FALSE)
    } else {
        # Slow path, have to redraw the picture multiple times, and without
        # the use of gridSVG features.
        # The gridSVG features cannot be used because things like clipping
        # paths or masks need to be redefined multiple times using multiple
        # different reference labels.
        gTree(children = do.call("gList",
            lapply(seq_len(npics), function(i) {
                pictureGrob(picture,
                            x = x[i], y = y[i],
                            width = size[i], height = size[i],
                            default.units = default.units,
                            gpFUN = gpFUN, ext = ext, ...)
            })
        ))
    }
}

grid.symbols <- function(...) {
    grid.draw(symbolsGrob(...))
}

