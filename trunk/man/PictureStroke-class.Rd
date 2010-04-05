\name{PictureStroke-class}
\docType{class}
\alias{PictureStroke-class}
\alias{grobify,PictureStroke-method}
\alias{symbolize,PictureStroke-method}

\title{Class "PictureStroke" }
\description{A polyline path (that might be part of a larger picture). }
\section{Slots}{
	 \describe{
    \item{\code{x}:}{Object of class \code{"numeric"} }
    \item{\code{y}:}{Object of class \code{"numeric"} }
    \item{\code{rgb}:}{Object of class \code{"character"} giving the 
colour of the polyline. }
    \item{\code{lwd}:}{Object of class \code{"numeric"} giving the
width of the polyine. }
  }
}
\section{Extends}{
Class \code{"PictureOp"}, directly.
}
\section{Methods}{
  \describe{
    \item{grobify}{\code{signature(object = "PictureStroke")}: 
convert into a grid  grob (for one-off drawing). }
    \item{symbolize}{\code{signature(object = "PictureStroke")}: 
convert into a grid  grob (for drawing as a data symbol)). }
	 }
}
\author{ Paul Murrell }
\seealso{
\code{\link{Picture-class}},
\code{\link{PictureFill-class}},
and 
\code{\link{grid.picture}},
\code{\link{grid.symbols}}.
}
\keyword{classes}
