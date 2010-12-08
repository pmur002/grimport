\name{PictureFill-class}
\docType{class}
\alias{PictureFill-class}
\alias{grobify,PictureFill-method}
\alias{oldGrobify,PictureFill-method}
\alias{symbolize,PictureFill-method}
\alias{drawPath,PictureFill-method}

\title{Class "PictureFill" }
\description{A description of a polygon path (that might be part
of a larger picture).}
\section{Slots}{
	 \describe{
    \item{\code{x}:}{Object of class \code{"numeric"} }
    \item{\code{y}:}{Object of class \code{"numeric"} }
    \item{\code{rgb}:}{Object of class \code{"character"} 
that specifies the fill colour for the polygon.}
    \item{\code{lwd}:}{Object of class \code{"numeric"} 
that specifies the line width of the polygon (not typically
used because the polygon is meant to be  filled not stroked).}
  \item{\code{rule}:}{Object of class \code{"character"}
    with the value \code{evenodd} or \code{nonzero}
    indicating the fill rule for the path.}
  }
}
\section{Extends}{
Class \code{"PictureOp"}, directly.
}
\section{Methods}{
  \describe{
    \item{grobify}{\code{signature(object = "PictureFill")}: 
convert to a grid grob (for one-off drawing). There is a
      logical argument \code{use.gc} which can be used to turn off the
      graphics context coming from the object so that a different one
      can be specified via the \code{gp} argument.}
    \item{symbolize}{\code{signature(object = "PictureFill")}: 
convert to a grid grob (for drawing as a data symbol).}
    \item{drawPath}{\code{signature(object = "PictureFill")}:
      draws a traced polygonx as part of the current plot.}
    }
}
\author{ Paul Murrell }
\seealso{
\code{\link{Picture-class}},
\code{\link{PictureStroke-class}},
and
\code{\link{grid.picture}},
\code{\link{grid.symbols}}.
}
\keyword{classes}
