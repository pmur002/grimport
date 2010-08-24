\name{readPicture}
\alias{readPicture}
\title{ Import an RGML file }
\description{
  This function reads in an RGML file (produced by
  \code{\link{PostScriptTrace}}) and creates a
  \code{"Picture"} object.
}
\usage{
readPicture(rgmlFile, tidy = TRUE, \dots)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{rgmlFile}{ The name of the RGML file. }
  \item{tidy}{ Boolean indicating whether to replace non-printing
    characters in string values with a full stop.  The default is
    \code{TRUE}, which is just trying to keep you safe.  But I
    strongly believe in the user's right to live dangerously. }
  \item{\dots}{ Arguments that are passed to \code{xmlTreeParse()}
    for reading the RGML file. }
}
\value{
  An object of class \code{"Picture"}.
}
\author{ Paul Murrell }
\seealso{
  \code{\link{PostScriptTrace}}
}
\keyword{ dplot }% at least one, from doc/KEYWORDS
