\name{picture}
\alias{picture}
\title{ Draw a Picture Object }
\description{
  This function take a \code{"Picture"} object and draw it
  in the current plot region.
}
\usage{
picture(picture, xleft, ybottom, xright, ytop, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{picture}{
    A \code{"Picture"} object.
  }
  \item{xleft}{
    The location for the left edge of the picture.
  }
  \item{ybottom}{
    The location for the bottom edge of the picture.
  }
  \item{xright}{
    The location for the right edge of the picture.
  }
  \item{ytop}{
    The location for the top edge of the picture.
  }
  \item{\dots}{
    graphical parameters.
  }
}
\details{
     The positions supplied, i.e., \code{xleft, ...}, are relative to the
     current plotting region.  If the x-axis goes from 100 to 200 then
     \code{xleft} should be larger than 100 and \code{xright} should be
     less than 200.
}
\author{
  Paul Murrell
}
\seealso{
\code{\link{readPicture}} and
\code{\link{grid.picture}}
}
\keyword{ dplot }% at least one, from doc/KEYWORDS
