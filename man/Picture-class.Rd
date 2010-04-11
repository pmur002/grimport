\name{Picture-class}
\docType{class}
\alias{Picture-class}
\alias{[,Picture-method}
\alias{[[,Picture-method}
\alias{grobify,Picture-method}
\alias{symbolize,Picture-method}

\title{Class "Picture"}
\description{A collection of paths (polylines or polygons)
that together describe a picture.}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("Picture", ...)}.
	 ~~ describe objects here ~~ 
}
\section{Slots}{
	 \describe{
    \item{\code{paths}:}{A list of objects of class \code{"PictureStroke"}
(polylines) or \code{"PictureFill"} (polygons).}
    \item{\code{summary}:}{Object of class \code{"PictureSummary"} }
  }
}
\section{Methods}{
  \describe{
    \item{[}{\code{signature(x = "Picture")}: subset the paths of a picture
to produce a new picture (includeing a new, updated summary). }
    \item{[[}{\code{signature(x = "Picture")}: extract either a single
      path or, more usefully, the sub-paths of a \code{"PictureText"}
      object, to produce a new picture (includeing a new, updated summary). }
    \item{grobify}{\code{signature(object = "Picture")}: convert a picture
into  a grid grob (for use as a one-off image). }
    \item{symbolize}{\code{signature(object = "Picture")}: convert a picture
into a grid grob (for use as a plotting symbol). }
	 }
}
\author{ Paul Murrell }
\seealso{
\code{\link{readPicture}},
\code{\link{grid.picture}},
\code{\link{grid.symbols}}
and 
\code{\link{PictureStroke-class}}
\code{\link{PictureFill-class}}
\code{\link{PictureSummary-class}}.
}
\keyword{classes}
