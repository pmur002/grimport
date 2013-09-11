\name{PostScriptTrace}
\alias{PostScriptTrace}
\title{ Convert PostScript file to RGML file }
\description{
  Converts a PostScript file into an RGML file, which is
  an XML document describing an image that can be read into R.
}
\usage{PostScriptTrace(file, outfilename,
                       charpath=TRUE, charpos=FALSE,
                       setflat=NULL, defaultcol="black",
                       encoding="ISO-8859-1")}
\arguments{
  \item{file}{The name of the PostScript file.}
  \item{outfilename}{The name of the XML document.}
  \item{charpath}{A boolean indicating whether text in the PostScript
    file should be converted to vector outlines, or left as just text.}
  \item{charpos}{A boolean indicating whether text in the PostScript
    file should be treated as individual characters, each with its
    own location.}
  \item{setflat}{A number that controls how many straight lines a curve
    is broken into.  Lower values break a curve into more lines. }
  \item{defaultcol}{The default colour to use when grImport is unable
    to determine a colour for a path. This may occur when patterns are
    present in a PostScript image.}
  \item{encoding}{A character value giving the encoding for the
    resulting RGML file.}
}
\details{
  This function calls ghostscript to do the conversion,
  so will only work if ghostscript is installed on your system.

  If text is converted to outlines, it can be drawn as outlines,
  or filled using a crude algorithm which may or may not work
  (see \code{grid.picture}).  On the other hand, if text is left
  as just text, font information is not stored so the text may
  not end up looking much like the original.

  Ghostscript is only going to emit text in a single-byte encoding,
  so the RGML file should have an explicit encoding (otherwise
  XML parsers are likely to assume UTF-8 and barf on any non-ASCII
  text).  The default encoding used is ISO-8859-1 (ISOLatin1),
  but you can specify another if you know that the source
  file has text that ghostscript will emit in a different
  encoding.  There may have to be a bit of guesswork, or
  inspection of the source PostScript file.
}
\references{
  \url{http://www.cs.wisc.edu/~ghost/}
}
\keyword{dplot}
