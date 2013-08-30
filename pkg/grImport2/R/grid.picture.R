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
    # If we have 
    if (gridSVG) {
        if (! require(gridSVG))
            warning("gridSVG must be installed to use the 'gridSVG' option")
        
    }


}

grid.symbols <- function(...) {
    grid.draw(symbolsGrob(...))
}


