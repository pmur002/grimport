
# Create a list straight from the RGML file
readPicture <- function(rgmlFile, ...) {
    funGetX = function(x) { as.numeric(xmlAttrs(x)["x"]) }
    funGetY = function(x) { as.numeric(xmlAttrs(x)["y"]) }
    funGetGC = function(x) { pars <- xmlApply(x, xmlAttrs) }
    funPathType = function(x) { xmlAttrs(x)["type"] }

    funPath = function(x) {
        switch(xmlName(x),
               path={ xval = unlist(xmlApply(x, funGetX))
                      yval = unlist(xmlApply(x, funGetY))

                      # get context
                      gc = funGetGC(xmlElementsByTagName(x, "context")[[1]])

                      # convert to a list of S4 objects
                      switch(funPathType(x),
                             stroke=new("PictureStroke", x=xval, y=yval,
                               lwd=as.numeric(gc$style["lwd"]),
                               lty=readLTY(gc$style["lty"]),
                               rgb=rgb(as.numeric(gc$rgb["r"]),
                                 as.numeric(gc$rgb["g"]),
                                 as.numeric(gc$rgb["b"]))),
                             fill=new("PictureFill", x=xval, y=yval,
                               lwd=as.numeric(gc$style["lwd"]),
                               lty=readLTY(gc$style["lty"]),
                               rgb=rgb(as.numeric(gc$rgb["r"]),
                                 as.numeric(gc$rgb["g"]),
                                 as.numeric(gc$rgb["b"]))),
                             char=new("PictureChar", x=xval, y=yval,
                               lwd=as.numeric(gc$style["lwd"]),
                               lty=readLTY(gc$style["lty"]),
                               rgb=rgb(as.numeric(gc$rgb["r"]),
                                 as.numeric(gc$rgb["g"]),
                                 as.numeric(gc$rgb["b"]))))
                  },
               text={ # get context
                      gc = funGetGC(xmlElementsByTagName(x, "context")[[1]])

                      new("PictureText",
                          string=xmlAttrs(x)["string"],
                          x=as.numeric(xmlAttrs(x)["x"]),
                          y=as.numeric(xmlAttrs(x)["y"]),
                          w=as.numeric(xmlAttrs(x)["width"]),
                          h=as.numeric(xmlAttrs(x)["height"]),
                          lwd=as.numeric(gc$style["lwd"]),
                          rgb=rgb(as.numeric(gc$rgb["r"]),
                            as.numeric(gc$rgb["g"]),
                            as.numeric(gc$rgb["b"])))
                  },
               summary={ attrs <- xmlAttrs(x)
                         numattrs <- as.numeric(xmlAttrs(x)) 
                         names(numattrs) <- names(attrs) 
                         numattrs })
    }

    xmlDoc = xmlTreeParse(rgmlFile, ...)
    version <- as.numeric(xmlAttrs(xmlRoot(xmlDoc))["version"])
    if (version != 3)
        stop(paste("Version mismatch:",
                   "RGML file needs to be recreated with PostScriptTrace()"))
    RGMLlist <- xmlApply(xmlRoot(xmlDoc), funPath)
    new("Picture",
        paths=RGMLlist[-length(RGMLlist)],
        summary=new("PictureSummary",
          numPaths=RGMLlist$summary["count"],
          xscale=RGMLlist$summary[c("xmin", "xmax")],
          yscale=RGMLlist$summary[c("ymin", "ymax")]))
}

# Given a list of paths, determine the bounding box
pathBounds <- function(paths) {
    pathXmin <- function(path) { min(path@x) }
    pathYmin <- function(path) { min(path@y) }
    pathXmax <- function(path) {
        if (is(path, "PictureText"))
            path@x + path@w
        else
            max(path@x)
    }
    pathYmax <- function(path) {
        if (is(path, "PictureText"))
            path@y + path@h
        else
            max(path@y)
    }
    list(xscale=c(min(sapply(paths, pathXmin)),
           max(sapply(paths, pathXmax))),
         yscale=c(min(sapply(paths, pathYmin)), 
           max(sapply(paths, pathYmax))))
}

setMethod("[", "Picture",
          function(x, i, j, drop) {
              paths <- x@paths[i]
              scales <- pathBounds(paths)
              new("Picture",
                  paths=paths,
                  summary=new("PictureSummary",
                    numPaths=length(paths),
                    xscale=scales$xscale,
                    yscale=scales$yscale))
          })



