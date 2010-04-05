
validDetails.picturetext <- function(x) {
  if (!is.unit(x$x) ||
      !is.unit(x$y) ||
      !is.unit(x$w) ||
      !is.unit(x$h) )
    stop("'x' and 'y' must be units")
  # Make sure that x and y are of length 1
  if (length(x$x) > 1 | length(x$y) > 1 ||
      length(x$w) > 1 | length(x$h) > 1 )
    stop("'x' and 'y' must have length 1")
  x
}

drawDetails.picturetext <- function(x, recording=TRUE) {
    # Determine size of string in current font
    currentWidth <- convertWidth(stringWidth(x$string), "inches",
                                 valueOnly=TRUE)
    desiredWidth <- convertWidth(x$w, "inches",
                                 valueOnly=TRUE)
    # Scale text to fill desired width
    grid.text(x$string, x$x, x$y,
              just=c("left", "bottom"),
              gp=gpar(cex=desiredWidth/currentWidth))
}

pictureTextGrob <- function(string, x, y, w, h,
                            units="native",
                            gp=gpar(), name=NULL, vp=NULL) {
    if (!is.unit(x))
        x <- unit(x, units)
    if (!is.unit(y))
        y <- unit(y, units)
    if (!is.unit(w))
        w <- unit(w, units)
    if (!is.unit(h))
        h <- unit(h, units)
    grob(string=as.character(string), x=x, y=y, w=w, h=h,
         gp=gp, name=name, vp=vp, cl="picturetext")
}
