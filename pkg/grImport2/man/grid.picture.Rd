\name{grid.picture}
\alias{pictureGrob}
\alias{grid.picture}
\title{
  Draw a Picture Object.
}
\description{
  These function take a \code{"Picture"} object and either draw the
  picture or create a grid graphical object representing the picture.
}
\usage{
pictureGrob(picture,
            x = unit(0.5, "npc"), y = unit(0.5, "npc"),
            width = unit(1, "npc"), height = unit(1, "npc"),
            just = "centre", hjust = NULL, vjust = NULL,
            default.units = "npc", expansion = 0.05,
            xscale = NULL, yscale = NULL, distort = FALSE,
            gpFUN = identity, ..., name = NULL)
grid.picture(...)
}
\arguments{
  \item{picture}{
    A \code{"Picture"} object.
  }
  \item{x}{
    A single numeric value or unit object specifying an x-value.
  }
  \item{y}{
    A single numeric value or unit object specifying a y-value.
  }
  \item{width}{
    A single numeric value or unit object specifying a width.
  }
  \item{height}{
    A single numeric value or unit object specifying a height.
  }
  \item{just}{
    The justification of the picture relative to its (x, y) location.
    If there are two values, the first value specifes horizontal
    justification and the second value specifies vertical justification.
    Possible string values are: \code{"left"}, \code{"right"},
    \code{"centre"}, \code{"center"}, \code{"bottom"}, and \code{"top"}.
    For numeric values, 0 means left alignment and 1 means right
    alignment.
  }
  \item{hjust}{
    A numeric vector specifying horizontal justification. If specified,
    overrides the \code{just} setting.
  }
  \item{vjust}{
    A numeric vector specifying vertical justification. If specified,
    overrides the \code{just} setting.
  }
  \item{default.units}{
    A string indicating the default units to use if \code{x}, \code{y},
    \code{width}, or \code{height} are only given as numeric vectors.
  }
  \item{expansion}{
    An expansion factor; determines whether any space is left
    between the extent of the picture and the bounding rectangle
    it is drawn within.
  }
  \item{xscale}{
    A numeric vector of length two indicating the minimum and maximum on
    the x-scale.
  }
  \item{yscale}{
    A numeric vector of length two indicating the minimum and
    maximum on the y-scale.
  }
  \item{distort}{
    A logical value indicating whether the image should preserve its
    aspect ratio or distort to fit the area it is being drawn
    within.
  }
  \item{gpFUN}{
    A function that takes in a grid \code{gpar} object and returns a
    (optionally modified) \code{gpar} object.
  }
  \item{\dots}{
    For \code{grid.picture}, arguments to be passed to
    \code{pictureGrob}. For \code{pictureGrob}, arguments to be passed
    to the picture object's \code{grobify} method.
  }
  \item{name}{
    A character identifier.
  }
}
\value{
  A grid gTree.
}
\author{
  Simon Potter
}
\seealso{
  \code{\link{grobify}}, \code{\link{grid.symbols}}.
}
