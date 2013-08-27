\name{PictureText-class}
\docType{class}
\alias{PictureText-class}
\alias{grobify,PictureText-method}
\alias{oldGrobify,PictureText-method}
\alias{symbolize,PictureText-method}
\alias{drawPath,PictureText-method}

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
    \item{\code{angle}:}{Object of class \code{"numeric"} }
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
      convert to a grid grob (for one-off drawing).  In addition to a
      \code{use.gc} argument, there is a \code{fillText} argument to
      specify whether to stroke or fill text paths.  Filling text paths
      is not necessarily a good idea because some characters have holes
      (e.g., the letter  \sQuote{o}).  The \code{bgText} argument can be
      used to specify a colour to use to fill these holes;  this
      argument can actually be a named vector of colours so that, e.g.,
      the hole in an \sQuote{o} is filled white, but the dot on an
      \sQuote{i} is filled black.  Finally, there is a
      \code{sizeByWidth} argument which controls whether text is sized
      based on the traced width or based on the traced height of the
      original text.
    }
    \item{symbolize}{\code{signature(object = "PictureText")}: 
      convert to a grid grob (for drawing as a data symbol).
      Currently draws nothing.
    }
    \item{drawPath}{\code{signature(object = "PictureText")}:
      draws a traced piece of text as part of the current plot.
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
