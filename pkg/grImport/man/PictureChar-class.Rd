\name{PictureChar-class}
\docType{class}
\alias{PictureChar-class}
\alias{grobify,PictureChar-method}
\alias{oldGrobify,PictureChar-method}
\alias{symbolize,PictureChar-method}
\alias{drawPath,PictureChar-method}

\title{Class "PictureChar" }
\description{A description of a polygon path that describes
  the outline of a character (and might be part
  of a larger picture).}
\section{Slots}{
	 \describe{
    \item{\code{x}:}{Object of class \code{"numeric"} }
    \item{\code{y}:}{Object of class \code{"numeric"} }
    \item{\code{rgb}:}{Object of class \code{"character"} 
      that specifies the fill colour for the polygon.}
    \item{\code{lwd}:}{Object of class \code{"numeric"} 
      that specifies the line width of the polygon (only
      used if the character outline is stroked).}
    \item{\code{char}:}{Object of class \code{"character"}
      that specifies the character that this path represents.}
  }
}
\section{Extends}{
Class \code{"PictureOp"}, directly.
}
\section{Methods}{
  \describe{
    \item{grobify}{\code{signature(object = "PictureChar")}: 
      convert to a grid grob (for one-off drawing).  Use
      argument \code{fillText} to fill the text rather than
      just stroke the outline.  In that case, the first path
      for this character is filled in the appropriate colour
      and all subsequent paths are filled using a colour controlled
      by the \code{bgText} argument (default is white).
    }
    \item{symbolize}{\code{signature(object = "PictureChar")}: 
      convert to a grid grob (for drawing as a data symbol).
      Currently draws nothing.
    }
    \item{drawPath}{\code{signature(object = "PictureChar")}:
      draws a traced character path as part of the current plot.
    }
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
