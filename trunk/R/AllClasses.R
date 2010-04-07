
# For RGML2picture
setClass("PictureOp",
         representation(x="numeric",
                        y="numeric",
                        rgb="character",
                        lty="numeric",
                        lwd="numeric"),
         prototype=list(rgb="black", lwd=1))

setClass("PictureStroke",
         representation("PictureOp"))

setClass("PictureFill",
         representation("PictureOp"))

setClass("PictureText",
         representation("PictureOp",
                        string="character",
                        w="numeric",
                        angle="numeric"))

setClass("PictureChar",
         representation("PictureOp"))

setClass("PictureSummary",
         representation(numPaths="numeric",
                        xscale="numeric",
                        yscale="numeric"))

setClass("Picture",
         representation(paths="list",
                        summary="PictureSummary"))

setValidity("Picture",
            function(object) {
                all(sapply(object@paths, is, "PictureOp"))
            })
                        
