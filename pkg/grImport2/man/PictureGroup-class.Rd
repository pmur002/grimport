\name{PictureGroup-class}
\docType{class}
\alias{PictureGroup-class}
\alias{[,PictureGroup-method}
\alias{[[,PictureGroup-method}
\alias{grobify,PictureGroup-method}
\title{Class \code{"PictureGroup"}}
\description{
  A grouped collection of picture pieces.
}
\section{Slots}{
  \describe{
    \item{\code{content}:}{
      Object of class \code{"list"} that is a list of objects of class
      \code{"PictureContent"}.
    }
    \item{\code{clip}:}{
      Object of class \code{"ANY"}. Either \code{NULL} or an object of
      class \code{"PictureClipPath"}.
    }
    \item{\code{filterRef}:}{
      Object of class \code{"ANY"}. A character reference to an object
      that will apply a filter effect to this group. Not intended to be
      used directly (so can be \code{NULL}.
    }
    \item{\code{maskRef}:}{
      Object of class \code{"ANY"}. A character reference to an object
      that will mask this group. Not intended to be used directly (so
      can be \code{NULL}.
    }
    \item{\code{gp}:}{
      Object of class \code{"gpar"}. A grid \code{gpar} object to apply
      to the group.
    }
  }
}
\section{Extends}{
  Class \code{"\linkS4class{PictureContent}"}, directly.
}
\section{Methods}{
  \describe{
    \item{[}{
      \code{signature(x = "PictureGroup")}: subset the content of the
      group to produce a new picture.
    }
    \item{[[}{
      \code{signature(x = "PictureGroup")}: extract a single piece of a
      picture group. Each piece will be an object of class
      \code{"PictureContent"}.
    }
    \item{grobify}{
      \code{signature(object = "PictureGroup")}: convert to a grid grob
      (for use as a one-off image) for drawing.

      This method is typically not called directly but can take four
      additional arguments.

      \describe{
        \item{\code{defs}}{
          This argument takes an object of class
          \code{"PictureDefinitions"}. This object allows us to make use
          of referenced content features in the gridSVG package.
        }
        \item{\code{gpFUN}}{
          This arugment takes a function that modifies a \code{gpar}
          object. The function should take a single argument that is a
          \code{gpar} object, modify that \code{gpar} object, and then
          return it. By default this argument is assigned the value of
          the identity function.
        }
        \item{\code{gridSVG}}{
          A logical value. When \code{TRUE}, this enables advanced
          graphical features provided by the gridSVG package. Such
          features include masking, filtering, pattern fills, etc.
        }
        \item{\code{clip}}{
          A character vector. This argument can partially match to one
          of \code{off}, \code{bbox}, or \code{gridSVG}. When
          \code{off}, no clipping is applied to the group. When
          \code{bbox}, the contents of the group will be clipped to the
          bounding box of the clipping definition. When \code{gridSVG},
          the contents of the group will be clipped to the non-zero
          region defined by the clipping definition. \code{bbox} is
          restricted to rectangular clipping regions, while
          \code{gridSVG} has no such restriction and can clip to any
          arbitrary region.
        }
      }
    }
  }
}
\author{
  Simon Potter
}
\keyword{classes}
