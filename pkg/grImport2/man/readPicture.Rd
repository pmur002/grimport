\name{readPicture}
\alias{readPicture}
\title{ Import a Cairo SVG image }
\description{
  This function reads in a Cairo SVG image file (produced by
  \code{convertPicture} from the grConvert package) and creates a
  \code{"Picture"} object.
}
\usage{
readPicture(file)
}
\arguments{
  \item{file}{ The filename of a Cairo SVG image. }
}
\value{
  An object of class \code{"Picture"}.
}
\author{ Simon Potter }
