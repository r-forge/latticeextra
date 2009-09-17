\name{panel.xyarea}
\alias{panel.xyarea}
\alias{panel.qqmath.xyarea}
\title{
  Plot series as filled polygons.
}
\description{
  Plot series as filled polygons connected at given origin level (on y axis).
}
\usage{
panel.xyarea(x, y, groups = NULL, origin = NULL,
             col, border, lty, lwd, alpha, ...,
             panel.groups = panel.xyarea)

panel.qqmath.xyarea(x, f.value = NULL, distribution = qnorm,
                    qtype = 7, groups = NULL, ...)
}
\arguments{
  \item{x, y}{
    data vectors.
  }
  \item{groups}{
    a factor defining groups.
  }
  \item{origin}{
    level on y axis to connect the start and end of the series.
    If \code{NULL}, the polygon is filled to the bottom of the panel.
  }
  \item{col, border, lty, lwd, alpha}{
    graphical parameters taken from
    \code{trellis.par.get("plot.polygon")} or
    \code{trellis.par.get("superpose.polygon")} (when groups defined).
  }
  \item{\dots}{
    further arguments passed on to \code{\link{panel.polygon}}.
    For \code{panel.qqmath.xyarea}, passed to \code{panel.xyarea}.
  }
  \item{panel.groups}{
    used in \code{\link{panel.superpose}}.
  }
  \item{f.value, distribution, qtype}{
    as in \code{\link{panel.qqmath}}.
  }
}
\details{
  none yet.
}
\author{
  Felix Andrews \email{felix@nfrac.org}
}
\seealso{
  \code{\link{panel.xyplot}}
}
\examples{
xyplot(sunspot.year ~ 1700:1988, panel = panel.xyarea, origin = 0)

qqmath(~ data, make.groups(baseline = rnorm(100), other = rnorm(100) * 2 - 0.5),
  groups = which, distribution = qunif,
  panel = panel.qqmath.xyarea, auto.key = list(points = FALSE, rectangles = TRUE),
  par.settings = modifyList(col.whitebg(), simpleTheme(alpha = 0.5, lwd = c(2,NA))))
}
\keyword{ dplot }
