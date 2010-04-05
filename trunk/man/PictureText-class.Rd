\name{PictureText-class}
\docType{class}
\alias{PictureText-class}
\alias{grobify,PictureText-method}
\alias{symbolize,PictureText-method}

\title{Class "PictureText" }
\description{A description of a piece of text to draw,
  at a particular location and a particular size (and it might be part
  of a larger picture).}
\section{Slots}{
	 \describe{
    \item{\code{string}:}{Object of class \code{"character"} }
    \item{\code{x}:}{Object of class \code{"numeric"} }
    \item{\code{y}:}{Object of class \code{"numeric"} }
    \item{\code{w}:}{Object of class \code{"numeric"} }
    \item{\code{h}:}{Object of class \code{"numeric"} }
    \item{\code{rgb}:}{Object of class \code{"character"} 
that specifies the fill colour for the polygon.}
    \item{\code{lwd}:}{Object of class \code{"numeric"} 
that specifies the line width of the polygon (only
used if the character outline is stroked).}
  }
}
\section{Extends}{
Class \code{"PictureOp"}, directly.
}
\section{Methods}{
  \describe{
    \item{grobify}{\code{signature(object = "PictureText")}: 
      convert to a grid grob (for one-off drawing).
    }
    \item{symbolize}{\code{signature(object = "PictureText")}: 
      convert to a grid grob (for drawing as a data symbol).
      Currently draws nothing.
    }
  }
}
\author{ Paul Murrell }
\seealso{
\code{\link{Picture-class}},
\code{\link{PictureChar-class}},
and
\code{\link{grid.picture}},
\code{\link{grid.symbols}}.
}
\keyword{classes}
