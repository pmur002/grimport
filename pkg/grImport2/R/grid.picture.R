pictureGrob <- function(picture, 
                        x = unit(0.5, "npc"), y = unit(0.5, "npc"),
                        width = unit(1, "npc"), height = unit(1, "npc"),
                        just = "centre", hjust = NULL, vjust = NULL,
                        default.units = "npc",
                        exp = 0.05, xscale = NULL, yscale = NULL,
                        distort = FALSE,
                        gpFUN = identity, ...,
                        name = NULL) {
    grobify(picture, 
            x = x, y = y,
            width = width, height = height,
            just = just,
            exp = exp,
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
                        gpFUN = identity,
                        ...,
                        name = NULL) {
    symbolize(picture,
              x = x, y = y, size = size, default.units = default.units,
              gpFUN = gpFUN, ..., name=name)
}

grid.symbols <- function(...) {
    grid.draw(symbolsGrob(...))
}


