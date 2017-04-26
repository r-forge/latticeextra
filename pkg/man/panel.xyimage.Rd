\name{panel.xyimage}
\alias{panel.xyimage}
\title{
  Scatter plots using emoji-like images
}
\description{
  Panel function that create scatter plots with emoji-like images for
  plotting character. Images can be local files or URLs. Only PNG and
  JPEG images are currently supported.
}
\usage{
panel.xyimage(x, y, 
              subscripts,
              groups = NULL,
              pch = NULL,
              cex = 1,
              ...,
              grid = FALSE, abline = NULL,
              identifier = "xyplot")
}
\arguments{
  \item{x, y}{
    data vectors.
  }
  \item{groups}{
    a factor defining groups.
  }
  \item{pch}{
  }
  \item{\dots}{
    Further arguments are accepted but ignored.
  }
}
\details{
  none yet.
}
\author{
  Felix Andrews \email{felix@nfrac.org}
}
\seealso{
  \code{\link{panel.xyplot}},
  \code{\link{panel.polygon}}
}
\examples{
xyplot(sunspot.year, panel = panel.xyarea, origin = 0,
  aspect = "xy", cut = list(n = 3, overlap = 0))

## two series superposed: one filled, one as a line.
xyplot(ts.union(data = sunspot.year, lag10 = lag(sunspot.year, 10)),
  aspect = "xy", cut = list(n = 3, overlap = 0),
  superpose = TRUE,
  panel = panel.superpose,
  panel.groups = function(..., group.number) {
    if (group.number == 1)
      panel.xyarea(...) else panel.xyplot(...)
  }, border = NA, 
  par.settings = simpleTheme(col = c("grey", "black"), lwd = c(5,2)))

## missing values are handled by splitting the series
tmp <- window(sunspot.year, start = 1900)
tmp[c(1:2, 50:60)] <- NA
xyplot(tmp, panel = panel.xyarea, origin = 0)

set.seed(0)
qqmath(~ data, make.groups(baseline = rnorm(100),
                           other = rnorm(100) * 2 - 0.5),
  groups = which, distribution = qunif,
  panel = panel.qqmath.xyarea, xlim = 0:1,
  auto.key = list(points = FALSE, rectangles = TRUE),
  par.settings = simpleTheme(col = c("blue", "green"),
                             alpha = 0.5))
}
\keyword{ dplot }
