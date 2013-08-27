\name{grid.symbols}
\alias{symbolsGrob}
\alias{grid.symbols}
\title{
  Draw a Picture Object as Data Symbols
}
\description{
  These functions take a \code{"Picture"} object and either draw the
  picture at several locations or create a grid graphical object
  representing the picture (drawn at several locations).
}
\usage{
symbolsGrob(picture,
            x = stats::runif(10), y = stats::runif(10),
            size = unit(1, "char"),
            default.units = "native",
            gpFUN = identity, ..., name = NULL)
grid.symbols(...)
}
\arguments{
  \item{picture}{
    A \code{"Picture"} object.
  }
  \item{x}{
    A numeric vector or unit object specifying x-locations.
  }
  \item{y}{
    A numeric vector or unit object specifying y-locations.
  }
  \item{size}{
    A numeric vector or unit object specifying symbol sizes.
  }
  \item{default.units}{
    A string indicating the default units to use if \code{x}, \code{y},
    \code{width}, or \code{height} are only given as numeric vectors.
  }
  \item{gpFUN}{
    A function that takes a grid \code{gpar} object and returns a
    (possibly modified) \code{gpar} object.
  }
  \item{\dots}{
    For \code{grid.symbols()}, arguments to be passed onto
    \code{symbolsGrob()}. For \code{symbolsGrob()}, additional
    parameters to be passed onto the \code{picture}'s \code{grobify}
    method.
  }
  \item{name}{
    A character identifier.
  }
}
\value{
  A grid grob.
}
\author{
  Simon Potter
}
\seealso{
  \code{\link{grid.picture}}
}
