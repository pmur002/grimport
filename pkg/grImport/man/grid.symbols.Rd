\name{grid.symbols}
\alias{grid.symbols}
\alias{symbolsGrob}
\title{ Draw a Picture Object }
\description{
  These function take a \code{"Picture"} object and
  either draw the picture at several locations
  or create a grid graphical object
  representing the picture (drawn at several locations).
}
\usage{
grid.symbols(...)
symbolsGrob(picture, x = unit(0.5, "npc"), y = unit(0.5, "npc"),
            size = unit(1, "npc"), units = "npc", ...,
            name = NULL, gp = gpar())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{picture}{A \code{"Picture"} object.}
  \item{x}{A numeric vector or unit object specifying x-values.}
  \item{y}{A numeric vector or unit object specifying y-values.}
  \item{size}{A numeric vector or unit object specifying symbol size.}
  \item{units}{The default units to use if \code{x}, \code{y},
    or \code{size} are specified as simple numeric values.}
  \item{\dots}{For \code{grid.symbols} arguments to be passed to
    \code{symbolsGrob}.  For \code{symbolsGrob}, arguments to be
    passed to \code{symbolize}.}
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
  \code{\link{symbolize}} and 
  \code{\link{grid.picture}}
}
\keyword{ dplot }% at least one, from doc/KEYWORDS
