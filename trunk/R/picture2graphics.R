
# Draw a "picture" object in the current plot region

setGeneric("drawPath",
           function(p, trans, ...) {
               standardGeneric("drawPath")
           })

setMethod("drawPath", signature(p="PictureStroke"),
          function(p, trans, ...) {
              lines(trans(p@x, p@y), col=p@rgb, lwd=p@lwd)
          })

setMethod("drawPath", signature(p="PictureFill"),
          function(p, trans, ...) {
              polygon(trans(p@x, p@y), col=p@rgb, border=NA)
          })

setMethod("drawPath", signature(p="PictureText"),
          function(p, trans, ...) {
              text(trans(p@x, p@y), labels=p@string, col=p@rgb)
          })

setMethod("drawPath", signature(p="PictureChar"),
          function(p, trans, ...) {
              cPaths <- explode(p, TRUE, "white")
              lapply(cPaths, drawPath, trans)
          })

picture <- function(picture, xleft, ybottom, xright, ytop, ...) {
    # Determine the conversion from picture coordinates
    # to plot coordinates
    dx <- xright - xleft
    dy <- ytop - ybottom
    xscale <- picture@summary@xscale
    yscale <- picture@summary@yscale
    trans <- function(x, y) {
        list(x=xleft + (x - min(xscale))/diff(xscale) * dx,
             y=ybottom + (y - min(yscale))/diff(yscale) * dy)
    }
    invisible(lapply(picture@paths, drawPath, trans))
}
