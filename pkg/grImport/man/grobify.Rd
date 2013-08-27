\name{grobify}
\alias{grobify}
\alias{oldGrobify}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Convert a Picture into a Grid Grob }
\description{
  Converts an entire \code{"Picture"} object, or
  a path element thereof,
  into an appropriate grid grob.  Not usually called directly
  by the user;  usually called by \code{grid.picture}.
}
\usage{
grobify(object, ...)

oldGrobify(object, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{ A \code{"Picture"} object. }
  \item{\dots}{ Arguments passed on to the relevant
    grid grob constructor function. }
}
\value{
  A grid gTree (when given a whole \code{"Picture"})
  or an appropriate grid grob (when given a single picture path).
}
\author{ Paul Murrell }
\seealso{
  \code{\link{grid.picture}} and  
  \code{\link{symbolize}}
}
\keyword{ dplot }% at least one, from doc/KEYWORDS
