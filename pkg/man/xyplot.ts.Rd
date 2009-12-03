\name{xyplot.ts}
\alias{xyplot.ts}
\alias{llines.ts}
\alias{panel.lines.ts}
\title{
  Plot time series using the Trellis framework
}
\description{
  Time series plotting, including cut-and-stack plots.
  Examples are given of superposing, counterposing and overlaying
  different time series.
}

\usage{
\S3method{xyplot}{ts}(x, data = NULL, type = "l", auto.key = TRUE, cut = FALSE,
          default.scales = list(), ...)

\S3method{llines}{ts}(x, y = NULL, ...)
## Note: panel.lines() also works.
}

\arguments{
  \item{x}{
    an object of class \code{\link{ts}}, which may be multi-variate,
    i.e. have a matrix structure with multiple columns.
  }
  \item{data}{
    ignored.
  }
  \item{type}{
    see \code{\link[lattice]{panel.xyplot}}.
  }
  \item{auto.key, default.scales}{
    see \code{\link[lattice]{xyplot}}.
  }
  \item{cut}{
    defines a cut-and-stack plot. \code{cut} should be a \code{list} of
    arguments to the function \code{\link[graphics:coplot]{co.intervals}},
    i.e. \code{number} (number of intervals to divide into, default 6)
    and \code{overlap} (the fraction of overlap between cuts, default
    0.5). \code{cut = TRUE} uses these default values.
  }
  \item{\dots}{
    further arguments to \code{xyplot.ts} are passed to
    \code{\link[lattice]{xyplot}}.
  }
  \item{y}{
    if specified, will revert to the default \code{llines} method.
  }
}

\details{
  This is a fairly simple wrapper which constructs a formula and calls
  the standard \code{xyplot} function. The terms on the left side of the
  formula correspond to the series in \code{x}, and the right side is
  \code{time(x)}. For cut-and-stack plots it is also conditioned on a
  \code{shingle} constructed from \code{time(x)}.
}

\value{
  An object of class \code{"trellis"}. The
  \code{\link[lattice:update.trellis]{update}} method can be used to
  update components of the object and the
  \code{\link[lattice:print.trellis]{print}} method (usually called by
  default) will plot it on an appropriate plotting device.
}

\references{
  Sarkar, Deepayan (2008) \dQuote{Lattice: Multivariate Data
  Visualization with R}, Springer.  ISBN: 978-0-387-75968-5
  \url{http://lmdvr.r-forge.r-project.org/}
}

\author{ Deepayan Sarkar \email{deepayan.sarkar@r-project.org} }

\seealso{
  \code{\link[lattice]{xyplot}},
  \code{\link{panel.xblocks}},
  \code{\link[zoo]{xyplot.zoo}} in the \pkg{zoo} package.
}

\examples{
## Figure 14.1 from Sarkar (2008)
xyplot(sunspot.year, aspect = "xy",
       strip = FALSE, strip.left = TRUE,
       cut = list(number = 4, overlap = 0.05))

## A multivariate example; first superposed, then counterposed
xyplot(EuStockMarkets)
xyplot(EuStockMarkets, outer = TRUE, aspect = "xy", type = c("l","g"),
       ylim = c(0, max(EuStockMarkets)), par.settings = simpleTheme(lwd = 2))
p <- trellis.last.object()

## Add ylabs corresponding to each panel
(p <- update(p, ylab = rep("price", 4), scales = list(alternating = 1)))

## Overlaying other time series on the plot
## Calculate mean of all 4 series in EuStockMarkets each day
meanSeries <- ts(rowMeans(EuStockMarkets), start = start(EuStockMarkets),
                 frequency = frequency(EuStockMarkets))
## Moving average of the SMI series over 260 days
smi260 <- filter(EuStockMarkets[,"SMI"], rep(1/260,260))
## Add the mean series to all panels, and smi260 only to panels 1 and 2
p <- p + layer(panel.lines(meanSeries), style = 2) +
         layer(panel.lines(smi260), style = 3, packets = c(1, 2))
(p <- update(p, key = simpleKey(c("data series", "mean", "260-day SMI"),
                                points = FALSE, lines = TRUE)))
}
\keyword{ hplot }
