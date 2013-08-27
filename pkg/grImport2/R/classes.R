# Import some S3 classes
setOldClass("gpar")
setOldClass("nativeRaster")

# We need to be able to transform objects when we create them
# we can do this via a transformation matrix acting upon the original object
setGeneric("applyTransform",
           function(object, tm) {
               standardGeneric("applyTransform")
           })

# Method useful for tracking the bounding boxes of the content of the image.
# Mostly useful for being able to reduce a picture and its bounding box
# to only a subset of the image.
setGeneric("getbbox",
           function(object, tm) {
               standardGeneric("getbbox")
           })

# Method for turning a picture object into a grid graphics object
setGeneric("grobify",
           function(object, ...) {
               standardGeneric("grobify")
           })

setGeneric("symbolize",
           function(object,
                    x = unit(0.5, "npc"),
                    y = unit(0.5, "npc"),
                    size = unit(1, "npc"),
                    default.units = "npc",
                    ...) {
               standardGeneric("symbolize")
           })

# Empty base class, just ensures that we can test whether
# children are valid pieces of a picture
setClass("PictureContent")

setClass("PictureClipPath",
         representation("PictureContent",
                        content = "list",
                        label = "character"))
setValidity("PictureClipPath",
            function(object) {
                length(object@content) &&
                all(sapply(object@content, is, "PictureContent"))
            })

setClass("PictureFeColorMatrix",
         representation("PictureContent",
                        type = "character",
                        input = "character",
                        values = "matrix"))

setClass("PictureFilter",
         representation("PictureContent",
                        filterUnits = "character",
                        x = "numeric", y = "numeric",
                        width = "numeric", height = "numeric",
                        content = "PictureFeColorMatrix"))

setClass("PictureGroup",
         representation("PictureContent",
                        content = "list",
                        clip = "ANY",
                        maskRef = "ANY",
                        filterRef = "ANY",
                        gp = "gpar"))

setValidity("PictureGroup",
            function(object) {
                # mask and filter can be ["NULL"|"character"]
                if (! is.null(object@maskRef) &&
                    ! is.character(object@maskRef)) return(FALSE)
                if (! is.null(object@filterRef) &&
                    ! is.character(object@filterRef)) return(FALSE)
                # Must have content and only "PictureContent".
                # Furthermore, only allow no clipping or a clipping path
                # object, essentially the representation of 'clip' is 
                # ["NULL"|"PictureClipPath"].
                if (length(object@content))
                    all(sapply(object@content, is, "PictureContent")) &&
                    (is.null(object@clip) ||
                     is(object@clip, "PictureClipPath"))
                else
                    (is.null(object@clip) ||
                     is(object@clip, "PictureClipPath"))
            })

setClass("PictureImage",
         representation("PictureContent",
                        x = "numeric",
                        y = "numeric",
                        width = "numeric",
                        height = "numeric",
                        image = "nativeRaster",
                        maskRef = "ANY",
                        bbox = "numeric"))

setClass("PictureMask",
         representation("PictureContent",
                        content = "list"))
setValidity("PictureMask",
            function(object) {
                length(object@content) &&
                all(sapply(object@content, is, "PictureContent"))
            })

# See paths.R for path segments and methods
# Definition of PathData must come before PicturePath
setClass("PathData",
         representation(segments = "list"))
setValidity("PathData",
            function(object) {
                all(sapply(object@segments, is, "PathSegment"))
            })

setClass("PicturePath",
         representation("PictureContent",
                        d = "PathData",
                        rule = "character",
                        gp = "gpar",
                        bbox = "numeric"))

setClass("PicturePattern",
         representation("PictureContent",
                        x = "numeric",
                        y = "numeric",
                        width = "numeric",
                        height = "numeric",
                        definition = "list"))

setClass("PictureRadialGradient",
         representation("PictureContent",
                        x = "numeric",
                        y = "numeric",
                        r = "numeric",
                        fx = "numeric",
                        fy = "numeric",
                        spreadMethod = "character",
                        stops = "list"))
setValidity("PictureRadialGradient",
            function(object) {
                all(sapply(object@stops, is, "PictureGradientStop"))
            })

setClass("PictureLinearGradient",
         representation("PictureContent",
                        x0 = "numeric",
                        y0 = "numeric",
                        x1 = "numeric",
                        y1 = "numeric",
                        spreadMethod = "character",
                        stops = "list"))
setValidity("PictureLinearGradient",
            function(object) {
                all(sapply(object@stops, is, "PictureGradientStop"))
            })

setClass("PictureGradientStop",
         representation(offset = "numeric",
                        col = "character"))

setClass("PictureRect",
         representation("PictureContent",
                        x = "numeric",
                        y = "numeric",
                        width = "numeric",
                        height = "numeric",
                        gp = "gpar",
                        bbox = "numeric"))

setClass("PictureSymbol",
         representation("PictureContent",
                        definition = "list"))

# Content should be a named list
setClass("PictureDefinitions",
         representation(content = "list"),
         prototype(content = list()))

setGeneric("getDef",
           function(object, id) standardGeneric("getDef"))

setMethod("getDef",
          signature(object = "PictureDefinitions",
                    id = "character"),
          function(object, id) {
              object@content[[id]]
          })

setGeneric("setDef",
           function(object, id, value) standardGeneric("setDef"))

setMethod("setDef",
          signature(object = "PictureDefinitions",
                    id = "character",
                    value = "PictureContent"),
          function(object, id, value) {
              object@content[[id]] <- value
              object
          })

setClass("PictureSummary",
         representation(xscale = "numeric",
                        yscale = "numeric"))

setClass("Picture",
         representation(content = "list",
                        defs = "PictureDefinitions",
                        summary = "PictureSummary"))

setValidity("Picture",
            function(object) {
                all(sapply(object@content, is, "PictureContent"))
            })

setMethod("[", "Picture",
          function(x, i, j, drop) {
              content <- x@content[i]
              allBounds <- lapply(content, getbbox)
              xmin <- min(sapply(allBounds, function(x) x[1]))
              xmax <- max(sapply(allBounds, function(x) x[2]))
              ymin <- min(sapply(allBounds, function(x) x[3]))
              ymax <- max(sapply(allBounds, function(x) x[4]))
              bbox <- c(xmin, xmax, ymin, ymax)
              summary <- new("PictureSummary",
                             xscale = bbox[1:2],
                             yscale = rev(bbox[3:4]))
              new("Picture",
                  content = content,
                  defs = x@defs,
                  summary = summary)
          })

setMethod("[[", "Picture",
          function(x, i, j, drop) {
              if (length(i) > 1)
                  stop("index must be length 1")
              x@content[[i]]
          })

setMethod("[", "PictureGroup",
          function(x, i, j, drop) {
              content <- x@content[i]
              new("PictureGroup",
                  content = content,
                  clip = x@clip,
                  gp = x@gp)
          })

setMethod("[[", "PictureGroup",
          function(x, i, j, drop) {
              if (length(i) > 1)
                  stop("index must be length 1")
              x@content[[i]]
          })

setMethod("applyTransform",
          signature(object = "gpar",
                    tm = "matrix"),
          function(object, tm) {
              gparNames <- names(object)
              scaleFactor <- min(tm[1, 1], tm[2, 2])
              if ("lwd" %in% gparNames)
                  object$lwd <- abs(object$lwd * scaleFactor)
              if ("lty" %in% gparNames)
                  object$lty <- abs(object$lty * scaleFactor)
              object 
          })

setMethod("applyTransform",
          signature(object = "PictureLinearGradient",
                    tm = "matrix"),
          function(object, tm) {
              locs <- matrix(c(object@x0,
                               object@x1,
                               object@y0,
                               object@y1,
                               rep(1, 2)),
                             ncol = 3)
              for (i in seq_len(nrow(locs)))
                  locs[i, ] <- tm %*% locs[i, ]
              object@x0 <- locs[1, 1]
              object@y0 <- locs[1, 2]
              object@x1 <- locs[2, 1]
              object@y1 <- locs[2, 2]
              object
          })

setMethod("applyTransform",
          signature(object = "PictureRadialGradient",
                    tm = "matrix"),
          function(object, tm) {
              locs <- matrix(c(object@x,
                               object@fx,
                               object@y,
                               object@fy,
                               rep(1, 2)),
                             ncol = 3)
              for (i in seq_len(nrow(locs)))
                  locs[i, ] <- tm %*% locs[i, ]
              object@x <- locs[1, 1]
              object@y <- locs[1, 2]
              object@fx <- locs[2, 1]
              object@fy <- locs[2, 2]
              # Assume minimum for scaling, but both values should be
              # the same so should not be strictly necessary
              object@r <- min(tm[1, 1], tm[2, 2]) * object@r
              object 
          })

# Really only need to be applied to the path data itself
setMethod("applyTransform",
          signature(object = "PicturePath",
                    tm = "matrix"),
          function(object, tm) {
              object@d <- applyTransform(object@d, tm)
              object@gp <- applyTransform(object@gp, tm)
              points <- getPoints(object@d, line = TRUE)
              object@bbox <- c(min(points$x), max(points$x),
                               min(points$y), max(points$y))
              object
          })

setMethod("applyTransform",
          signature(object = "PictureRect",
                    tm = "matrix"),
          function(object, tm) {
              object@x <- object@x + tm[1, 3]
              object@y <- object@y + tm[2, 3]
              object@width <- object@width * tm[1, 1]
              object@height <- object@height * tm[2, 2]
              object@gp <- applyTransform(object@gp, tm)
              object@bbox <- c(object@x, object@x + object@width,
                               object@y, object@y + object@height)
              object 
          })

setMethod("applyTransform",
          signature(object = "PictureImage",
                    tm = "matrix"),
          function(object, tm) {
              object@x <- object@x + tm[1, 3]
              object@y <- object@y + tm[2, 3]
              object@width <- object@width * tm[1, 1]
              object@height <- object@height * tm[2, 2]
              object@bbox <- c(object@x, object@x + object@width,
                               object@y, object@y + object@height)
              object 
          })

setMethod("getbbox",
          signature(object = "PictureClipPath"),
          function(object) {
              allBounds <- lapply(object@content, getbbox)
              xmin <- min(sapply(allBounds, function(x) x[1]))
              xmax <- max(sapply(allBounds, function(x) x[2]))
              ymin <- min(sapply(allBounds, function(x) x[3]))
              ymax <- max(sapply(allBounds, function(x) x[4]))
              c(xmin, xmax, ymin, ymax)
          })

setMethod("getbbox",
          signature(object = "PictureImage"),
          function(object) {
              object@bbox
          })

setMethod("getbbox",
          signature(object = "PictureRect"),
          function(object) {
              object@bbox
          })

setMethod("getbbox",
          signature(object = "PictureGroup"),
          function(object) {
              allBounds <- lapply(object@content, getbbox)
              xmin <- min(sapply(allBounds, function(x) x[1]))
              xmax <- max(sapply(allBounds, function(x) x[2]))
              ymin <- min(sapply(allBounds, function(x) x[3]))
              ymax <- max(sapply(allBounds, function(x) x[4]))
              c(xmin, xmax, ymin, ymax)
          })

setMethod("getbbox",
          signature(object = "PicturePath"),
          function(object) {
              object@bbox
          })

