\name{ggplot2like.theme}
\alias{ggplot2like.theme}
\alias{axis.grid}
\title{A ggplot2-like theme for Lattice}
\description{
  A theme for Lattice based on some of the default styles used in the
  \pkg{ggplot2} package by Hadley Wickham. Specifically, parts of the
  functions \code{scale_colour_hue}, \code{scale_colour_gradient} and
  \code{theme_gray} were copied. Although superficially similar, the
  implementation here lacks much of the flexibility of the \pkg{ggplot2}
  functions: see \url{http://had.co.nz/ggplot2/}.
}

\usage{
ggplot2like.theme(..., n = 6, h = c(0,360) + 15, l = 65, c = 100,
                  h.start = 0, direction = 1,
                  low = "#3B4FB8", high = "#B71B1A", space = "rgb")

axis.grid(side = c("top", "bottom", "left", "right"),
          scales, components, ...)
}
\arguments{
  \item{\dots}{
    further arguments passed on to \code{\link{simpleTheme}} to
    over-ride defaults.
  }
  \item{n}{
    number of \code{superpose} styles to generate, with equally spaced hues.
  }
  \item{h, c, l, h.start, direction}{
    range of hues, starting hue and direction to generate a discrete
    colour sequence with \code{\link{hcl}}.
  }
  \item{low, high, space}{
    extreme colors to interpolate with \code{\link{colorRampPalette}}
    for a continuous color scale.
  }
  \item{side, scales, components}{
    see \code{\link{axis.default}}. Typically \code{axis.grid} is not
    called directly so these should not be needed.
  }
}

\value{
  \code{ggplot2like.theme} produces a list of settings which can be
  passed as the \code{par.settings} argument to a high-level Lattice
  plot, or to \code{\link{trellis.par.set}}.

}
\author{
  Felix Andrews \email{felix@nfrac.org};
  copied from \pkg{ggplot2} by Hadley Wickham.
}
\seealso{
  the \pkg{ggplot2} package: \url{http://had.co.nz/ggplot2/}.
  
  \code{\link{custom.theme}}
}

\examples{
set.seed(0)

## basic theme, does not include white grid lines
xyplot(rnorm(30) ~ rnorm(30),
    par.settings = ggplot2like.theme())

xyg <- make.groups(
    "group one" = rnorm(30, 1),
    "group two" = rnorm(30, 2),
    "group three" = rnorm(30, 3))
xyg$x <- rev(xyg$data)

xyplot(data ~ x, xyg, groups = which, auto.key = TRUE)

xyplot(data ~ x, xyg, groups = which, auto.key = TRUE, 
    par.settings = ggplot2like.theme(n = 3), axis = axis.grid,
    xscale.components = xscale.components.subticks,
    yscale.components = yscale.components.subticks) +
  glayer(panel.abline(h = mean(y), ...))

bwplot(voice.part ~ height, data = singer,
    par.settings = ggplot2like.theme(), axis = axis.grid, 
    xscale.components = xscale.components.subticks,
    yscale.components = yscale.components.subticks)

}

\keyword{dplot}
