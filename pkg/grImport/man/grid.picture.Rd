\name{grid.picture}
\alias{grid.picture}
\alias{pictureGrob}
\title{ Draw a Picture Object }
\description{
  These function take a \code{"Picture"} object and
  either draw the picture or create a grid graphical object
  representing the picture.
}
\usage{
grid.picture(...)
pictureGrob(picture, x = 0.5, y = 0.5,
            width = 1, height = 1, just = "centre",
            exp = 0.05, xscale = NULL, yscale = NULL,
            distort = FALSE,
            FUN = grobify, ..., name = NULL, gp = gpar())

}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{picture}{A \code{"Picture"} object.}
  \item{x}{A single numeric value or unit object specifying an x-value.}
  \item{y}{A single numeric value or unit object specifying a y-value.}
  \item{width}{A single numeric value or unit object specifying a width.}
  \item{height}{A single numeric value or unit object specifying a
    height.}
  \item{just}{The justification of the picture
    relative to its (x, y) location.  If there are two values, the first
    value specifes horizontal justification and the second value specifies
    vertical justification.  Possible string values are: \code{"left"},
    \code{"right"}, \code{"centre"}, \code{"center"}, \code{"bottom"},
    and \code{"top"}.  For numeric values, 0 means left alignment
    and 1 means right alignment.
  }
  \item{exp}{An expansion factor;  determines whether any space
    is left between the extent of the picture and the bounding
    rectangle it is drawn within.}
  \item{xscale}{A numeric vector of length two indicating the minimum and
    maximum on the x-scale.}
  \item{yscale}{A numeric vector of length two indicating the minimum
    and maximum on the y-scale.}
  \item{distort}{A logical value indicating whether the image
    should preserve its aspect ratio or distort to fit the
    area it is being drawn within. }
  \item{FUN}{The function used to convert paths within the picture
    to grid grobs.}
  \item{\dots}{For \code{grid.picture} arguments to be passed to
    \code{pictureGrob}.  For \code{pictureGrob}, arguments to be
    passed to \code{grobify}.}
  \item{name}{ A character identifier. }
  \item{gp}{An object of class \code{gpar}, typically the output
    from a call to the function \code{gpar}.  This is basically
    a list of graphical parameter settings.}
}
\value{
  A grid gTree.
}
\author{ Paul Murrell }
\seealso{
  \code{\link{grobify}} and
  \code{\link{grid.symbols}}
}
\keyword{ dplot }% at least one, from doc/KEYWORDS
