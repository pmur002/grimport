pictureGrob <- function(picture, 
                        x = unit(0.5, "npc"), y = unit(0.5, "npc"),
                        width = unit(1, "npc"), height = unit(1, "npc"),
                        just = "centre", hjust = NULL, vjust = NULL,
                        default.units = "npc",
                        expansion = 0.05, xscale = NULL, yscale = NULL,
                        distort = FALSE,
                        gpFUN = identity, ...,
                        name = NULL) {
    grobify(picture, 
            x = x, y = y,
            width = width, height = height,
            just = just,
            expansion = expansion,
            xscale = xscale, yscale = yscale,
            distort = distort, gpFUN = gpFUN,
            ..., name = name)
}

grid.picture <- function(...) {
    grid.draw(pictureGrob(...))
}

symbolsGrob <- function(picture,
                        x = stats::runif(10),
                        y = stats::runif(10),
                        size = unit(1, "char"),
                        default.units = "native",
                        gpFUN = identity, gridSVG = FALSE,
                        ...,
                        name = NULL) {
    # If we have gridSVG, then there is a fast way of drawing everything.
    # Simply draw a bunch of rectangles and fill them with a pattern.
    # The pattern definition is the picture itself.
    if (gridSVG) {
        if (! require(gridSVG))
            warning("gridSVG must be installed to use the 'gridSVG' option")
        widths <- heights <- size
        rg <- rectGrob(x = x, y = y, width = widths, height = heights,
                       default.units = default.units, name = name)
        patdef <- pattern(pictureGrob(picture, gpFUN = gpFUN,
                                      gridSVG = TRUE, ...),
                          x = 0.5, y = 0.5, width = 1, height = 1,
                          dev.width = dev.size()[1],
                          dev.height = dev.size()[2])
        patternFillGrob(rg, patdef)
    } else {
        # Slow path, have to redraw the picture multiple times, and without
        # the use of gridSVG features.
        # The gridSVG features cannot be used because things like clipping
        # paths or masks need to be redefined multiple times using multiple
        # different reference labels.
        npics <- max(length(x), length(y), length(size))
        x <- rep(x, npics)
        y <- rep(y, npics)
        size <- rep(size, npics)
        gTree(children = do.call("gList",
            lapply(seq_len(npics), function(i) {
                pictureGrob(picture,
                            x = x[i], y = y[i],
                            width = size[i], height = size[i],
                            default.units = default.units,
                            gpFUN = gpFUN, ...)
            })
        ))
    }
}

grid.symbols <- function(...) {
    grid.draw(symbolsGrob(...))
}


