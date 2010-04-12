\name{drawPath}
\alias{drawPath}
\title{ Draw a Picture Object }
\description{
  This is a generic function that
  does the hard work for \code{picture} when
  drawing paths of a \code{"Picture"} object
  as part of the current plot.
}
\usage{
drawPath(p, trans, ...)
}
\arguments{
  \item{p}{A \code{"Picture"} object.}
  \item{trans}{
    A function that takes two arguments, \code{x} and \code{y},
    and can be used to transform the locations on a path
    into sensible coordinates within the current plot.
  }
  \item{\dots}{
    Other arguments, typically graphical parameters.
}
}
\author{ Paul Murrell }
\seealso{
  \code{\link{picture}} and 
  \code{\link{grid.picture}}  
}
\keyword{ dplot }% at least one, from doc/KEYWORDS
