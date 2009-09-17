\name{panel.qqmath.approx}
\alias{panel.qqmath.approx}
\title{
  Reduce number of points in qqmath for better speed / file size.
}
\description{
  Panel function for \code{\link{qqmath}} for plotting approximate
  distribution by reducing number of points. The resulting plots have
  a smaller file size and draw faster.
}
\usage{
panel.qqmath.approx(x, f.value = NULL, distribution = qnorm,
                    groups = NULL, ..., approx.n = 100, tails.n = 10)
}
\arguments{
  \item{x, f.value, distribution, groups}{
    see \code{\link{panel.qqmath}}.
  }
  \item{\dots}{
    further arguments passed on to \code{\link{panel.xyplot}}.
  }
  \item{approx.n}{
    number of points to use in approximating the distribution.
    Points will be equally spaced in the distribution space.
  }
  \item{tails.n}{
    number of points to retain (untouched) at both the high and low tails.
  }
}
\author{
  Felix Andrews \email{felix@nfrac.org}
}
\seealso{
  \code{\link{panel.qqmath}}
}
\examples{
xx <- rt(10000, df = 10)
c(panel.qqmath = qqmath(~xx),
  approx = qqmath(~xx, panel = panel.qqmath.approx))
}
\keyword{ dplot }
