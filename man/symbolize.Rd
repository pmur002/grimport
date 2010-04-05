\name{symbolize}
\alias{symbolize}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Convert a Picture into a Grid Grob }
\description{
  Converts an entire \code{"Picture"} object, or
  a path element thereof,
  into an appropriate grid grob.  Not usually called directly
  by the user;  usually called by \code{grid.picture}.
}
\usage{
symbolize(object, x = unit(0.5, "npc"), y = unit(0.5, "npc"),
          size = unit(1, "npc"), units = "npc", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{ A \code{"Picture"} object. }
  \item{x}{A numeric vector or unit object specifying x-values.}
  \item{y}{A numeric vector or unit object specifying y-values.}
  \item{size}{A numeric vector or unit object specifying symbol size.}
  \item{units}{The default units to use if \code{x}, \code{y},
    or \code{size} are specified as simple numeric values.}
  \item{\dots}{ Arguments passed on to the relevant
    grid grob constructor function. }
}
\value{
  A grid gTree (when given a whole \code{"Picture"})
  or a \code{"symbolFill"} or \code{"symbolStroke"} object
  (when given a single picture path).
}
\author{ Paul Murrell }
\seealso{
  \code{\link{grid.picture}} and  
  \code{\link{symbolize}}
}
\keyword{ dplot }% at least one, from doc/KEYWORDS
