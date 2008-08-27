\name{panel.voronoi}
\alias{panel.voronoi}
\alias{panel.levelplot.points}
\title{ Panel functions for level-coded irregular points }
\description{
  These panel functions for \code{\link[lattice]{levelplot}}
  can represent irregular (x, y) points with a color covariate.
  \code{panel.levelplot.points} simply draws color-coded points.
  \code{panel.voronoi} uses the \pkg{deldir} package to
  calculate the spatial extension of a set of points in 2 dimensions.
  This is known variously as a Voronoi mosaic, a Dirichlet tesselation,
  or Thiessen polygons.
}
\usage{
panel.voronoi(x, y, z, subscripts = TRUE, at = pretty(z),
   points = TRUE, border = "transparent",
   na.rm = FALSE, win.expand = 0.07, use.tripack = FALSE,
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
    to draw. Typically passed by \code{\link[lattice]{levelplot}}. }
  \item{at, col.regions, alpha.regions}{ color scale definition;
    see \code{\link[lattice]{panel.levelplot}}. }
  \item{points}{ whether to draw the (x, y) points. }
  \item{border}{ colour for polygon borders. }
  \item{na.rm}{ if \code{TRUE}, points with missing \code{z} values will
    be excluded from the calculation of polygons. If \code{na.rm = FALSE},
    those polygons are calculated but are not drawn (i.e. are
    transparent). }
  \item{win.expand}{ defines the rectangular window bounding the
    polygons. This is a factor by which
    to expand the range of the data. Set to 0 to limit drawing at the
    furthest data point locations. Ignored if \code{use.tripack = TRUE}. }
  \item{use.tripack}{ if \code{TRUE}, use \code{tripack} package rather
    than \code{deldir}. See Details. }
  \item{\dots}{ further arguments are
    passed to \code{\link[lattice]{panel.xyplot}} if \code{points = TRUE}. }
  \item{shrink, labels, label.style, contour, region, fill}{ ignored. }
}
\details{
  The tripack package implementation is faster than deldir but not under a
    fully free licence. Also, the deldir package allows polygons to
    be clipped to a rectangular window (the \code{win.expand} argument).
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{ \code{\link{tileplot}},
  \code{\link[lattice]{panel.levelplot}},
  \code{\link[deldir]{deldir}}  }
\examples{
xyz <- data.frame(x = rnorm(100), y = rnorm(100), z = rnorm(100))
levelplot(z ~ x * y, xyz)
levelplot(z ~ x * y, xyz, panel = panel.voronoi)
levelplot(z ~ x * y, xyz, panel = panel.levelplot.points)
}
\keyword{ hplot }
