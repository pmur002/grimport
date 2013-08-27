\name{PicturePattern-class}
\docType{class}
\alias{PicturePattern-class}
\alias{grobify,PicturePattern-method}

\title{Class \code{"PicturePattern"}}
\description{
  A description of a pattern to be referenced (and used) by graphical
  content.
}
\section{Slots}{
  \describe{
    \item{\code{x}:}{
      Object of class \code{"numeric"}. A vector of length one
      representing the x-location of the top-left corner of the
      pattern.
    }
    \item{\code{y}:}{
      Object of class \code{"numeric"}. A vector of length one
      representing the y-location of the top-left corner of the
      pattern.
    }
    \item{\code{width}:}{
      Object of class \code{"numeric"}. A vector of length one
      representing the width of the pattern.
    }
    \item{\code{height}:}{
      Object of class \code{"numeric"}. A vector of length one
      representing the height of the pattern.
    }
    \item{\code{definition}:}{
      Object of class \code{"list"}. A list of \code{"PictureContent"}
      objects that define the content of the pattern "tile".
    }
  }
}
\section{Extends}{
  Class \code{\linkS4class{PictureContent}}, directly.
}
\section{Methods}{
  \describe{
    \item{grobify}{\code{signature(object = "PicturePattern")}:
      convert the pattern description into a gridSVG pattern
      object. Useful only in conjunction with the gridSVG package. The
      pattern object will store the definition of the pattern (almost
      certainly a raster of some sort) as a grob too.

      While not intended to be used directly, this method contains a
      single optional argument. This argument is \code{gridSVG} and it
      holds the value of \code{TRUE}. When \code{TRUE}, it is possible
      to apply masking to the pattern definition using the gridSVG
      package. When \code{FALSE}, no masking will be applied.
    }
  }
}
\author{
  Simon Potter
}
