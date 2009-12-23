\name{panel.tskernel}
\alias{panel.tskernel}
\title{
  Plot a smoothed time series.
}
\description{
  Compute and plot discrete symmetric smoothing kernels.
  These kernels can be used to smooth time series objects.
  Options include moving averages, triangular filters, or
  approximately Gaussian filters.
}
\usage{
panel.tskernel(x, y, ...,
    m, c = 1, sides = 2, circular = FALSE,
    kern = kernel("daniell", rep(round(m / sqrt(c)), c)))
}
\arguments{
  \item{x, y}{
    data points. Should define a regular, ordered series.
    Alternatively a time series object can be passed as the
    first argument, and \code{y} can be omitted.
  }
  \item{\dots}{
    further arguments passed on to \code{\link{panel.lines}}.
  }
  \item{m}{
    number of time steps on one side of the kernel. In the default case,
    which is a simple moving average, the total width is \code{(m*2+1)}.
    When \code{c > 1} the number of time steps changes but the equivalent
    bandwidth stays the same.
  }
  \item{c}{
    smoothness of the kernel: \code{c = 1} is a moving average,
    \code{c = 2} is a triangular kernel, \code{c = 3} and higher
    approximate smooth Gaussian kernels.

    \code{c} is actually the number of times to
    recursively convolve the basic kernel with itself. The basic kernel
    is a simple moving average of \code{(m*2+1)} steps.

    The kernel dimension is adjusted to maintain a constant equivalent
    bandwidth as \code{c} increases.
  }
  \item{sides}{
    if \code{sides=1} the smoothed series is calculed from past values
    only; if \code{sides=2} it is centred around lag 0.
  }
  \item{circular}{
    to treat the data as circular (periodic).
  }
  \item{kern}{
    a \code{tskernel} object; if given, this over-rides \code{m} and \code{c}.
  }
}
\details{
  I am not an expert on time series theory.
}
\author{
  Felix Andrews \email{felix@nfrac.org}
}
\seealso{
  \code{\link{kernel}},
  \code{\link{filter}}
}
\examples{
## a Gaussian-like filter (contrast with c = 1 or c = 2)
xyplot(sunspot.year) +
layer(panel.tskernel(x, y, m = 10, c = 3, col = 1, lwd = 2))

## example from ?kernel:
## long and short moving averages, backwards in time
xyplot(EuStockMarkets[,1]) +
  layer(panel.tskernel(x, y, m = 50, col = 1, sides = 1)) +
  layer(panel.tskernel(x, y, m = 10, col = 2, sides = 1))

## per group, with a triangular filter
xyplot(EuStockMarkets) +
  glayer(panel.tskernel(..., m = 50, c = 2),
         theme = simpleTheme(lwd = 2))

## plot the actual kernels used; note adjustment of m
devAskNewPage(TRUE)
m = 100
for (c in 1:5) {
    k <- kernel("daniell", rep(round(m / sqrt(c)), c))
    plot(k)
    message("c: ", c, ", bandwidth: ", bandwidth.kernel(k))
}

}
\keyword{ dplot }
