\name{panel.voronoi}
\alias{panel.voronoi}
\alias{panel.levelplot.points}
\title{ Panel functions for level-coded irregular points }
\description{
  These panel functions for \code{\link{levelplot}}
  can represent irregular (x, y) points with a color covariate.
  \code{panel.levelplot.points} simply draws color-coded points.
  \code{panel.voronoi} uses the \pkg{interp} or \pkg{deldir} package to
  calculate the spatial extension of a set of points in 2 dimensions.
  This is known variously as a Voronoi mosaic, a Dirichlet tesselation,
  or Thiessen polygons.
}
\usage{
panel.voronoi(x, y, z, subscripts = TRUE, at = pretty(z),
   points = TRUE, border = "transparent",
   na.rm = FALSE, win.expand = 0.07, use.tripack = FALSE,
   backend = c("interp", "deldir"),
   ...,
   col.regions = regions$col, alpha.regions = regions$alpha)

panel.levelplot.points(x, y, z, subscripts = TRUE, at = pretty(z),
   shrink, labels, label.style, contour, region,
   pch = 21, col.symbol = "#00000044",
   ...,
   col.regions = regions$col, fill = NULL)
}
\arguments{
  \item{x, y, z}{ an irregular set of points at locations (x, y) with
    value z. }
  \item{subscripts}{ integer vector indicating what subset of x, y and z
    to draw. Typically passed by \code{\link{levelplot}}. }
  \item{at, col.regions, alpha.regions}{ color scale definition;
    see \code{\link{panel.levelplot}}. }
  \item{points}{ whether to draw the (x, y) points. }
  \item{border}{ color for polygon borders. }
  \item{na.rm}{ if \code{TRUE}, points with missing \code{z} values will
    be excluded from the calculation of polygons. If \code{FALSE},
    those polygons are calculated but are not drawn (i.e. are
    transparent). }
  \item{win.expand}{ defines the rectangular window bounding the
    polygons. This is a factor by which
    to expand the range of the data. Set to 0 to limit drawing at the
    furthest data point locations. Ignored if \code{use.tripack = TRUE}. }
  \item{use.tripack}{ Ignored, with a warning if a value is
    specified.See Details. }
  \item{backend}{ Character string specifying backend package to use to
    calculate the Voronoi mosaic. Defaults to \code{"interp"}.}
  \item{\dots}{Additional arguments; passed to
    \code{\link{panel.xyplot}} if \code{points = TRUE}. }
  \item{pch, col.symbol}{ symbol and border color for points.
    A filled symbol should be used, i.e. in the range 21-25. }
  \item{shrink}{ Ignored. }
  \item{labels}{ Ignored. }
  \item{label.style}{ Ignored. }
  \item{contour}{ Ignored. }
  \item{region}{ Ignored. }
  \item{fill}{ Ignored. }
}
\details{
  Up to version 0.6-29, latticeExtra used the \pkg{deldir} package to
  compute the Voronoi mosaic by default, while offering the choice of
  using the faster but non-free ACM licensed implementation in the
  \pkg{tripack} package by setting \code{use.tripack = TRUE}. Later
  versions use the FOSS replacements in \pkg{interp} by default, and
  deprecates the \code{use.tripack} argument. The \pkg{deldir}
  implementation, which allows polygons to be clipped to a rectangular
  window (the \code{win.expand} argument), can still be used using
  \code{backend = "deldir"}.
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{ \code{\link{tileplot}},
  \code{\link{panel.levelplot}},
  \code{\link[deldir]{deldir}}  }
\examples{
## a variant of Figure 5.6 from Sarkar (2008)
## http://lmdvr.r-forge.r-project.org/figures/figures.html?chapter=05;figure=05_06

depth.ord <- rev(order(quakes$depth))
quakes$Magnitude <- equal.count(quakes$mag, 4)
quakes.ordered <- quakes[depth.ord, ]

levelplot(depth ~ long + lat | Magnitude, data = quakes.ordered,
         panel = panel.levelplot.points, type = c("p", "g"),
         aspect = "iso", prepanel = prepanel.default.xyplot)

## a levelplot with jittered cells

xyz <- expand.grid(x = 0:9, y = 0:9)
xyz[] <- jitter(as.matrix(xyz))
xyz$z <- with(xyz, sqrt((x - 5)^2 + (y - 5)^2))
levelplot(z ~ x * y, xyz, panel = panel.voronoi, points = FALSE)

## hexagonal cells

xyz$y <- xyz$y + c(0, 0.5)
levelplot(z ~ x * y, xyz, panel = panel.voronoi, points = FALSE)
}
\keyword{ hplot }
