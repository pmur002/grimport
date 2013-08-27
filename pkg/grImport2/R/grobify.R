setMethod("grobify",
          signature(object = "PictureClipPath"),
          function(object, defs, gpFUN = identity, gridSVG = TRUE, ...) {
              if (is.null(object@content) || ! length(object@content))
                  return(gTree())
              children <- lapply(object@content, grobify,
                                 defs = defs, gpFUN = gpFUN,
                                 gridSVG = gridSVG)
              gTree(children = do.call("gList", children))
          })

setMethod("grobify",
          signature(object = "PictureFeColorMatrix"),
          function(object) {
              feColorMatrix(input = object@input,
                            type = object@type,
                            values = object@values)
          })

setMethod("grobify",
          signature(object = "PictureFilter"),
          function(object, ...) {
              # defs are not needed, nor gpFUN, and gridSVG is implied
              filterEffect(grobify(object@content),
                           filterUnits = object@filterUnits,
                           x = object@x, y = object@y,
                           width = object@width, height = object@height,
                           just = c("left", "bottom"))
          })

setMethod("grobify",
          signature(object = "PictureMask"),
          function(object, defs, gpFUN = identity, gridSVG = TRUE, ...) {
              if (is.null(object@content) || ! length(object@content))
                  return(mask(gTree()))
              children <- lapply(object@content, grobify,
                                 defs = defs, gpFUN = gpFUN,
                                 gridSVG = gridSVG)
              mask(gTree(children = do.call("gList", children)))
          })

setMethod("grobify",
          signature(object = "PicturePattern"),
          function(object, gridSVG = TRUE, ...) {
              # Ignoring gpFUN because it will only be applied to a
              # raster and gp settings do not apply to rasters.

              # dims in inches
              # We need this because the device needs to be only as large
              # as the pattern (as parsed by grImport), no more.
              win <- abs(convertWidth(unit(object@width, "native"),
                                      "inches", valueOnly = TRUE))
              hin <- abs(convertHeight(unit(object@height, "native"),
                                      "inches", valueOnly = TRUE))

              # Convert to inches because when grabbing the raster
              # later, we would otherwise run into issues. This is because
              # the dims of the image are flattened to inches and cannot
              # be reverted. We need the original inches for gridSVG.
              firstDef <- object@definition[[1]]
              w <- convertWidth(unit(firstDef@width, "native"), "inches")
              h <- convertHeight(unit(firstDef@height, "native"), "inches")
              tilegrob <- rasterGrob(firstDef@image,
                                     x = 0, y = 0,
                                     width = w, height = abs(h),
                                     default.units = "inches",
                                     just = c("left", "bottom"))
              if (gridSVG && ! is.null(firstDef@maskRef) &&
                  length(firstDef@maskRef))
                  tilegrob <- maskGrob(tilegrob, label = firstDef@maskRef)

              # Draw a pattern.
              # The pattern has some dimensions, but these dimensions
              # must be matched by the width of the pattern tile device.
              pattern(tilegrob,
                      x = object@x, y = object@y,
                      width = object@width, height = object@height,
                      default.units = "native", just = c("left", "bottom"),
                      dev.width =  win, dev.height = hin)
          })

setMethod("grobify",
          signature(object = "PictureImage"),
          function(object, gridSVG = TRUE, ...) { 
              # Note gpFUN is not used here because it has no effect on
              # rasterGrobs. The 'grid' documentation points out that all
              # gpar settings are *ignored*.
              r <- rasterGrob(object@image,
                              x = object@x,
                              y = unit(1, "npc") - unit(object@y, "native"),
                              width = object@width, height = -object@height,
                              default.units = "native",
                              just = c("left", "bottom"))
              # Note, could add gridSVG features but we know only masks
              # can be applied to an <image>
              if (gridSVG && length(object@maskRef) && length(object@maskRef))
                  maskGrob(r, label = object@maskRef)
              else
                  r
          })

setMethod("grobify",
          signature(object = "PictureRadialGradient"),
          function(object, ...) {
              stops <- lapply(object@stops, grobify)
              offsets <- sapply(stops, function(x) x$offset)
              cols <- sapply(stops, function(x) x$col)
              radialGradient(col = cols,
                             stops = offsets,
                             gradientUnits = "coords",
                             x = object@x,
                             y = object@y,
                             r = object@r,
                             fx = object@fx,
                             fy = object@fy,
                             spreadMethod = object@spreadMethod,
                             default.units = "native")
          })

setMethod("grobify",
          signature(object = "PictureLinearGradient"),
          function(object, ...) {
              stops <- lapply(object@stops, grobify)
              offsets <- sapply(stops, function(x) x$offset)
              cols <- sapply(stops, function(x) x$col)
              linearGradient(col = cols,
                             stops = offsets,
                             gradientUnits = "coords",
                             x0 = object@x0,
                             x1 = object@x1,
                             y0 = object@y0,
                             y1 = object@y1,
                             spreadMethod = object@spreadMethod,
                             default.units = "native")
          })

setMethod("grobify",
          signature(object = "PictureGradientStop"),
          function(object, ...) {
              list(offset = object@offset, col = object@col)
          })

setMethod("grobify",
          signature(object = "PictureRect"),
          function(object, defs, gpFUN = identity, gridSVG = TRUE, ...) {
              object@gp <- gpFUN(object@gp)
              grob <- picRectGrob(object@x, object@y,
                                  object@width, object@height,
                                  just = c("left", "bottom"),
                                  default.units = "native",
                                  gp = object@gp)
              if (gridSVG)
                  grob <- gridSVGAddFeatures(grob, object@gp, defs)
              grob
          })

setMethod("grobify",
          signature(object = "PicturePath"),
          function(object, defs, gpFUN = identity, gridSVG = TRUE, ...) {
              # Due to the complex nature of SVG paths, we require a bit
              # of calculation in order to translate these into R paths.
              ismt <- sapply(object@d@segments, is, "PathMoveTo")
              nsp <- sum(ismt) # number of subpaths, always at least 1
              starts <- which(ismt)
              groupSize <- diff(c(starts, length(ismt) + 1))
              ngroups <- length(groupSize)

              # Lines should have fewer points than a path (when there
              # are close paths present
              linePoints <- getPoints(object@d, line = TRUE)
              pathPoints <- getPoints(object@d, line = FALSE)

              if (ngroups == 1) {
                  # No need to split into sub-grobs because we only have
                  # a single region to consider
                  pidlen <- lidlen <- NULL
              } else {
                  # Complex case where we need to consider how the sub-grobs
                  # are split into different groups. Collecting the lengths
                  # of each sub-grob group
                  pidlen <- lidlen <- numeric(ngroups)
                  for (i in seq_len(ngroups)) {
                      groupInds <- starts[i] + 0:(groupSize[i] - 1)
                      lidlen[i] <- sum(sapply(object@d@segments[groupInds],
                                              function(x) {
                          length(getPoints(x, line = TRUE)$x)
                      }))
                      pidlen[i] <- sum(sapply(object@d@segments[groupInds],
                                              function(x) {
                          length(getPoints(x, line = FALSE)$x)
                      }))

                      # If pidlen is less than lidlen *and* pidlen is only
                      # length 1 this means that the path data is simply a
                      # MOVETO and a CLOSEPATH. In other words, this subpath
                      # does nothing.
                      # Just assume that we have a LINETO instead (which draws
                      # no line), this makes things a bit easier than removing.
                      # This is because the subpath will still match the
                      # associated polyline fragment. Furthermore, it means
                      # that when exporting via gridSVG, the sub-grob ID
                      # is a bit more sensible (because it is not removing an
                      # empty group).
                      if (pidlen[i] < lidlen[i] && pidlen[i] == 1) {
                          # i == 1 is a simple append case
                          if (i == 1) {
                              pathPoints$x <- c(pathPoints$x[1],
                                                pathPoints$x)
                              pathPoints$y <- c(pathPoints$y[1],
                                                pathPoints$y)
                          } else {
                              # last position plus one (current)
                              pos <- sum(pidlen[1:(i - 1)])
                              pathPoints$x <- append(pathPoints$x,
                                                     pathPoints$x[pos], after = pos)
                              pathPoints$y <- append(pathPoints$y,
                                                     pathPoints$y[pos], after = pos)
                          }

                          # We now have two points, so use that
                          pidlen[i] <- 2
                      }
                  }
              }

              object@gp <- gpFUN(object@gp)

              # Create a complex path grob.
              # The complication with this grob arises due to the fact that
              # SVG <polyline>s can have a fill region, whereas the R (and
              # therefore grid) graphics engine cannot.
              # A polyline draws the stroke, while a path draws the fill
              # region of the *SVG* path.
              # This produces the same effect when the stroke is drawn above
              # the filled path (which picComplexPathGrob attempts to ensure)
              grob <- picComplexPathGrob(linePoints, pathPoints,
                                         lidlen, pidlen,
                                         object@rule, object@gp)
              if (gridSVG)
                  grob <- gridSVGAddFeatures(grob, object@gp, defs)
              grob
          })

setMethod("grobify",
          signature(object = "PictureGroup"),
          function(object, defs, gpFUN = identity, gridSVG = TRUE,
                   clip = c("off", "bbox", "gridSVG"), ...) {
              clip <- match.arg(clip)
              clipvp <-
                  if (! is.null(object@clip) && clip == "bbox") {
                      cp <- object@clip
                      bbox <- getbbox(cp)
                      clipVP(bbox[1:2], bbox[3:4])
                  } else {
                      NULL
                  }
              object@gp <- gpFUN(object@gp)
              childTree <- lapply(object@content,
                                  grobify, defs = defs,
                                  gpFUN = gpFUN, gridSVG = gridSVG,
                                  clip = clip)
              groupGrob <- gTree(children = do.call("gList", childTree),
                                 gp = object@gp,
                                 vp = clipvp)
              if (! is.null(object@clip) && clip == "gridSVG") {
                  cp <- object@clip
                  groupGrob <- clipPathGrob(groupGrob, label = cp@label)
              }
              if (gridSVG)
                  groupGrob <-
                      gridSVGAddFeatures(groupGrob, object@gp, defs,
                                         object@maskRef, object@filterRef)
              groupGrob
          })

setMethod("grobify",
          signature(object = "Picture"),
          function(object, gpFUN = identity, gridSVG = FALSE,
                   clip = c("off", "bbox", "gridSVG"), ...) {
              clip <- match.arg(clip)

              if (gridSVG || clip == "gridSVG") {
                  if (! require(gridSVG)) {
                      warning("the 'gridSVG' package is required for advanced graphical features")
                      gridSVG <- FALSE
                      if (clip == "gridSVG")
                          clip <- "bbox"
                  }
                  # Things like gradients and patterns need to be aware of
                  # native scales at the time of registration. Because of
                  # this we also set the gradient and pattern labels to be
                  # the same as the SVG IDs.
                  pushViewport(pictureVP(object),
                               recording = FALSE)
                  registerDefs(object@defs)
                  popViewport(recording = FALSE)
              }

              children <- lapply(object@content,
                                 grobify, defs = object@defs,
                                 gpFUN = gpFUN, gridSVG = gridSVG,
                                 clip = clip)
              gTree(children = do.call("gList", children),
                    vp = pictureVP(object))
          })
