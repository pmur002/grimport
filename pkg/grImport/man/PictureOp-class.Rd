\name{PictureOp-class}
\docType{class}
\alias{PictureOp-class}

\title{Class "PictureOp" }
\description{
A virtual class from which \code{"PictureStroke"}
and \code{"PictureFill"} are derived.
}
\section{Slots}{
	 \describe{
    \item{\code{x}:}{Object of class \code{"numeric"} }
    \item{\code{y}:}{Object of class \code{"numeric"} }
    \item{\code{rgb}:}{Object of class \code{"character"}
      giving colour information for the path. }
    \item{\code{lty}:}{Object of class \code{"numeric"}
      giving line type information for the path. }
    \item{\code{lwd}:}{Object of class \code{"numeric"}
      giving line width information for the path. }
    \item{\code{lineend}:}{Object of class \code{"numeric"}
      giving the type of line end style (round, butt, square). }
    \item{\code{linejoin}:}{Object of class \code{"numeric"}
      giving the type of line join style (round, mitre, bevel). }
    \item{\code{linemitre}:}{Object of class \code{"numeric"}
      giving the line mitre limit (as a number greater than 1). }
  }
}
\author{ Paul Murrell }
\seealso{
\code{\link{PictureStroke-class}} and
\code{\link{PictureFill-class}}.
}
\keyword{classes}
