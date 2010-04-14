\name{panel.xblocks}
\alias{panel.xblocks}
\alias{panel.xblocks.default}
\alias{panel.xblocks.ts}
\alias{panel.xblocks.zoo}
\title{
  Plot contiguous blocks along x axis.
}
\description{
  Plot contiguous blocks along x axis. A typical use would be to
  highlight events or periods of missing data.
}
\usage{
panel.xblocks(x, ...)

\S3method{panel.xblocks}{default}(x, y, ..., col = NULL, border = NA, 
              height = unit(1, "npc"),
              block.y = unit(0, "npc"), vjust = 0,
              name = "xblocks", gaps = FALSE,
              last.step = median(diff(tail(x))))

\S3method{panel.xblocks}{ts}(x, y = NULL, ...)
}
\arguments{
  \item{x, y}{
    In the default method, \code{x} gives the ordinates along the x axis and
    must be in increasing order. \code{y} gives the color values to plot as
    contiguous blocks. If \code{y} is numeric, data coverage is plotted,
    by converting it into a logical (\code{!is.na(y)}). In this case, or
    when a logical \code{y} is given, the default block color is taken
    from the current theme: \code{trellis.par.get("plot.line")$col}. 
    
    If \code{y} has character (or factor) values, these are interpreted
    as colors -- and should therefore be color names or hex
    codes. Missing values in \code{y} are not plotted.  If \code{col} is 
    given, this over-rides the block colors.

    The \code{ts} method plots values against their \code{time()},
    unless \code{y} is specified, when it acts just like the default
    method. 
  }
  \item{\dots}{
    In the default method, further arguments are graphical parameters
    passed on to \code{\link[grid]{gpar}}.
  }
  \item{col}{
    if \code{col} is specified, it determines the colors of the blocks
    defined by \code{y}. If multiple colors are specified they will be
    repeated to cover the total number of blocks.
  }
  \item{border}{
    border color.
  }
  \item{height}{
    height of blocks, defaulting to the full panel height. Numeric
    values are interpreted as native units.
  }
  \item{block.y}{
    y axis position of the blocks. Numeric values are interpreted as
    native units.
  }
  \item{vjust}{
    vertical justification of the blocks relative to \code{block.y}. See
    \code{\link[grid]{grid.rect}}.
  }
  \item{name}{
    a name for the grob (\pkg{grid} object).
  }
  \item{gaps}{
    Deprecated.
    Use \code{panel.xblocks(time(z), is.na(z))} instead.
  }
  \item{last.step}{
    width (in native units) of the final block. Defaults to the median of
    the last 5 time steps (assuming steps are regular).
  }
}
\details{
  Blocks are drawn forward in "time" from the specified x locations,
  up until the following value. Contiguous blocks are calculated using
  \code{\link{rle}}.
}
\author{
  Felix Andrews \email{felix@nfrac.org}
}
\seealso{
  \code{\link[lattice]{xyplot.ts}},
  \code{\link{panel.rect}},
  \code{\link[grid]{grid.rect}}
}
\examples{
## Example of highlighting peaks in a time series.
set.seed(0)
flow <- ts(filter(rlnorm(200, mean = 1), 0.8, method = "r"))

## using an explicit panel function
xyplot(flow, panel = function(x, y, ...) {
  panel.xblocks(x, y > mean(y), col = "lightgrey")
  panel.xyplot(x, y, ...)
})
## using layers; this is the `ts` method because `>` keeps it as ts.
xyplot(flow) +
  layer_(panel.xblocks(flow > mean(flow), col = "lightgrey"))

\dontshow{ .featured_example <- TRUE }
## Example of alternating colors, here showing calendar months
flowdates <- Sys.Date() + as.vector(time(flow))
xyplot(flow) +
  layer_(panel.xblocks(time(flow), months(flowdates),
         col = c("lightgrey", "#e6e6e6"), border = "darkgrey"))

## Example of highlighting gaps (NAs) in time series.
## set up example data
z <- ts(cbind(A = 0:5, B = c(6:7, NA, NA, 10:11), C = c(NA, 13:17)))

## show data coverage only (highlighting gaps)
xyplot(z, panel = panel.xblocks,
       scales = list(y = list(draw = FALSE)))

## draw gaps in red
xyplot(z, type = c("p","s")) +
  layer_(panel.xblocks(x, is.na(y), col = "red"))

## Example of overlaying blocks from a different series.
## Are US presidential approval ratings linked to sunspot activity?
## Set block height, default justification is along the bottom.
xyplot(presidents) + layer(panel.xblocks(sunspot.year > 50, height = 3))
## Multiple color values given in the 'y' argument.
sscols <- cut(sunspot.year, c(50,150,Inf), labels=c("yellow","orange"))
xyplot(presidents, lwd = 2) +
  layer_(panel.xblocks(time(sunspot.year), y = sscols))

}
\keyword{ dplot }
