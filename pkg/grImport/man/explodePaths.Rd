\name{explodePaths}
\alias{explodePaths}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Explode Complex Picture Paths }
\description{
  This function converts complex paths within a \code{"Picture"} object
  (paths that contain more than one move operation) into multiple
  simple paths (paths with only one move operation).
}
\usage{
explodePaths(picture)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{picture}{ A \code{"Picture"} object. }
}
\value{ A \code{"Picture"} object. }
\author{ Paul Murrell }
\seealso{
  \code{\link{grid.picture}}
}
\keyword{ dplot }% at least one, from doc/KEYWORDS
