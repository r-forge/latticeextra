\name{horizonplot}
\alias{horizonplot}
\alias{horizonplot.default}
\alias{panel.horizonplot}
\alias{prepanel.horizonplot}
\title{ Plot many time series in parallel }

\description{
  Plot many time series in parallel by cutting the y range into segments
  and overplotting them with color representing the magnitude and
  direction of deviation.
}

\usage{
horizonplot(x, data, \dots)

\S3method{horizonplot}{default}(x, data = NULL, \dots,
            panel = panel.horizonplot,
            prepanel = prepanel.horizonplot,
            strip = FALSE, groups = NULL,
            layout = c(1, NA),
            default.scales = list(
                y = list(relation = "sliced", draw = FALSE)))

panel.horizonplot(x, y, ..., origin,
             border = NA, col.regions = regions$col)

prepanel.horizonplot(x, y, ..., origin = function(y) na.omit(y)[1])
}

\arguments{
  \item{x}{ Argument on which argument dispatch is carried
    out. Typically this will be a multivariate time series.
  }
  \item{data}{
    Not used, and must be left as \code{NULL}.
  }
  \item{\dots}{ further arguments.  Arguments to \code{xyplot} as
    well as to the default panel function \code{\link{panel.horizonplot}}
    can be supplied directly to \code{horizonplot}. }
  \item{panel}{ function to render the graphic given the data.  This is
    the function that actually implements the display.  }
  \item{prepanel}{ function determining range of the data rectangle from
    data to be used in a panel. }
  \item{strip}{
    by default strips are not drawn, to save space.
  }
  \item{groups}{
    not applicable to this type of plot.
  }
  \item{layout, default.scales}{
    see xyplot.
  }
  \item{origin}{
    the baseline y value for the first (positive) segment. This can be a
    number, which is then fixed across all panels, or it can be a
    function, which is evaluated with the \code{y} values in each
    panel. The default is the first non-missing y value in each
    panel.

    See the Details section.
  }
  \item{border}{
    border color for the filled polygons, defaults to no border.
  }
  \item{col.regions}{
    color scale, taken by default from the current theme,
    \code{trellis.par.get("regions")$col}. This should be a divergent
    color scale (with white as the central color).
  }
}

\details{
  This function draws time series as filled areas, with modifications
  to effectively visualise many time series in parallel. Data that would
  be drawn off the top of each panel is redrawn from the bottom of the
  panel in a darker color. Values below the origin are inverted and
  drawn in the opposite color. There are up to three shades (typically
  in blue) for data above the baseline and up to three shades (typically
  in red) for data below the baseline. See the article referenced below
  for an introduction to Horizon plots.

  Note that the y scale in each panel defines the actual origin and
  scale used. The \code{origin} argument is only used in the \code{prepanel}
  function to choose an appropriate y scale (it is ignored by the
  \code{panel} function). The \code{ylim} argument therefore over-rides
  \code{origin}. The choice of \code{scales$y$relation} is also crucial;
  see \code{\link[lattice]{xyplot}} and the examples below.
}


\value{
  An object of class \code{"trellis"}. The
  \code{\link[lattice:update.trellis]{update}} method can be used to
  update components of the object and the
  \code{\link[lattice:print.trellis]{print}} method (usually called by
  default) will plot it on an appropriate plotting device.
}

\references{
  Stephen Few (2008). Time on the Horizon.
  \emph{Visual Business Intelligence Newsletter}, June/July 2008
  \url{http://www.perceptualedge.com/articles/visual_business_intelligence/time_on_the_horizon.pdf}
}

\author{
  Felix Andrews \email{felix@nfrac.org}
}

\seealso{
  \code{\link[lattice]{Lattice}},
  \code{\link[lattice]{xyplot.ts}},
  \code{\link{panel.xyarea}}
}

\examples{
## generate a random time series object with 12 columns
set.seed(1)
dat <- ts(matrix(cumsum(rnorm(200)), nrow = 200, ncol = 12)) +
          matrix(cumsum(rnorm(200 * 12)), ncol = 12)
colnames(dat) <- paste("series", LETTERS[1:12])

## draw each series with a different baseline;
## ('origin' default is the first data value in each series).
## distances are comparable, but not values (scales = "sliced").
horizonplot(dat, scales = list(y = list(draw = FALSE)),
    ylab = list(colnames(dat), rot = 0))

## use same scales in each panel
## (so colours represent fixed ranges across all panels)
horizonplot(dat, scales = "same")
horizonplot(dat, scales = "same", origin = 0)

## illustration of the cut points used in the following plot
xyplot(EuStockMarkets, scales = list(y = "same"),
  panel = function(x, y, ...) {
    rgn <- trellis.par.get("regions")$col
    col <- rgn[1 + (length(rgn)-1) * 0:7/7]
    for (i in -4:3) {
      ilim <- 4000 + 1000 * c(i, i+1)
      panel.xyarea(x, pmax(pmin(y, ilim[2]), ilim[1]),
        origin = ilim[if (i < 0) 2 else 1], col = col[i+5])
    }
  })

## compare with previous plot
horizonplot(EuStockMarkets, strip.left = TRUE,
  scales = list(y = "same"), ylim = c(4000, 5000))

## a cut-and-stack plot; should use "same" y scales!
horizonplot(sunspots, cut = list(n = 23, overlap = 0),
  scales = list(y = "same", x = list(draw = FALSE)),
  origin = mean(sunspots)) +
layer(grid::grid.text(round(x[1]), x = 0, just = "left"))

}
\keyword{hplot}
\keyword{ts}
