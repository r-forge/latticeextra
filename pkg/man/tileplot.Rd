\name{tileplot}
\alias{tileplot}
\alias{panel.voronoi}
\title{ Plot a spatial mosaic from irregular 2D points }
\description{
  This panel function for \code{\link[lattice]{levelplot}}
  uses the \pkg{deldir} package to
  calculate the spatial extension of a set of points in 2 dimensions.
  This is known variously as a Voronoi mosaic, a Dirichlet tesselation,
  or Thiessen polygons.
}
\usage{
tileplot(x, data = NULL, aspect = "iso",
         prepanel = "prepanel.default.xyplot",
         panel = "panel.voronoi", ...)

panel.voronoi(x, y, z, subscripts = TRUE,
   points = TRUE, border = "transparent",
   na.rm = FALSE, win.expand = 0.07, use.tripack = FALSE,
   at = seq(min(z, na.rm = TRUE), max(z, na.rm = TRUE), length = 100),
   ...,
   col.regions = regions$col, alpha.regions = regions$alpha)
}
\arguments{
  \item{x, data}{ formula and data as in
    \code{\link[lattice]{levelplot}}, except that it expects irregularly
    spaced points rather than a regular grid. }
  \item{aspect}{ aspect ratio: "iso" is recommended as it reproduces the
    distances used in the triangulation calculations. }
  \item{panel, prepanel}{ see \code{\link[lattice]{xyplot}}. }
  \item{x, y, z}{ an irregular set of points at locations (x, y) with
    value z. }
  \item{subscripts}{ integer vector indicating what subset of x, y and z
    to draw. Typically passed by \code{\link[lattice]{levelplot}}. }
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
  \item{\dots}{ in \code{panel.voronoi}, further arguments are
    passed to \code{\link[lattice]{panel.xyplot}} if \code{points = TRUE}. }
  \item{at, col.regions, alpha.regions}{ color scale definition;
    see \code{\link[lattice]{panel.levelplot}}. }
}
\details{
  The tripack package implementation is faster than deldir but not under a
    fully free licence. Also, the deldir package allows polygons to
    be clipped to a rectangular window (the \code{win.expand} argument).
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{ \code{\link[lattice]{levelplot}}, \code{\link[deldir]{deldir}}  }
\examples{

xyz <- data.frame(x = rnorm(100), y = rnorm(100), z = rnorm(100))
tileplot(z ~ x * y, xyz)

## tripack is faster but non-free
\dontrun{
tileplot(z ~ x * y, xyz, use.tripack = TRUE)
}

## showing rectangular window boundary
tileplot(z ~ x * y, xyz, xlim = c(-2, 4), ylim = c(-2, 4))

## insert some missing values
xyz$z[1:10] <- NA
## the default na.rm = FALSE shows missing polygons
tileplot(z ~ x * y, xyz, border = "black",
  col.regions = grey.colors(100),
  pch = ifelse(is.na(xyz$z), 4, 21),
  panel = function(...) {
    panel.fill("hotpink")
    panel.voronoi(...)
  })
## use na.rm = TRUE to ignore points with missing values
update(trellis.last.object(), na.rm = TRUE)

## a quick and dirty approximation to US state boundaries
tmp <- state.center
tmp$Income <- state.x77[,"Income"]
tileplot(Income ~ x * y, tmp, border = "black",
  panel = function(x, y, ...) {
    panel.voronoi(x, y, ..., points = FALSE)
    panel.text(x, y, state.abb)
  })

}
\keyword{ hplot }

