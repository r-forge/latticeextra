\name{panel.lmlineq}
\Rdversion{1.1}
\alias{panel.lmlineq}
\alias{panel.ablineq}
\title{
  Draw a line and its equation.
}
\description{
  This is an extension of the panel functions \code{\link{panel.abline}} and
  \code{\link{panel.lmline}} to also draw the equation of a line.
}
\usage{
panel.ablineq(a = NULL, b = 0,
              h = NULL, v = NULL,
              reg = NULL, coef = NULL,
              pos, offset, adj,
              fontfamily = "serif",
              rotate = FALSE, srt = 0,
              r.squared = FALSE,
              ...,
              at.npc = 0.5, at.x, at.y,
              varNames = alist(y = y, x = x),
              varStyle = "italic",
              digits = 3, sep = ", ", sep.end = "")

panel.lmlineq(x, y, ...)
}
\arguments{
  \item{a, b, h, v, reg, coef}{
    specification of the line.
    The simplest usage is to give \code{a} and \code{b} to describe the
    line \emph{y = a + b x}.
    Horizontal or vertical lines can be specified as
    arguments \code{h} or \code{v}, respectively.
    The first argument (\code{a}) can also be a model object produced by
    \code{\link{lm}}.
    See \code{\link{panel.abline}} for more details.
  }
  \item{pos, offset, adj, fontfamily}{
    passed on to \code{\link{panel.text}}.
    For \code{pos}: 1 = below, 2 = left, 3 = above, 4 = right,
    and the \code{offset} (in character widths) is applied.
    For \code{adj}: c(0,0) = above right, c(1,0) = above left,
    c(0,1) = below right, c(1,1) = below left;
    offset does not apply when using \code{adj}.
  }
  \item{rotate, srt}{
    set \code{rotate = TRUE} to align the equation with the line.
    This will over-ride \code{srt}, which otherwise gives the rotation
    angle.
    Note that the calculated angle depends on the current device size;
    this will be wrong if you change the device aspect ratio after plotting.
  }
  \item{r.squared, sep, sep.end}{
    the R^2 statistic to display along with the equation of a line.
    This can be given directly as a number, or \code{TRUE}, in which
    case the function expects a model object (typically
    \code{\link{lm}}) and extracts the R^2 statistic from it.

    The R^2 value is separated from the equation by \code{sep}, and
    also \code{sep.end} is added to the end. For example:
    \code{panel.ablineq(lm(y ~ x), r.squared = TRUE, sep = " (", sep.end
    = ")")}.
  }
  \item{\dots}{
    passed on to \code{\link{panel.abline}} and \code{\link{panel.text}}.
  }
  \item{at.npc}{
    horizontal position of the equation within the panel. This is given
    in the range 0 to 1 (i.e. "npc", normalised parent coordinates).
    When a vertical line is drawn, this gives the vertical position of
    the equation.
  }
  \item{at.x, at.y}{
    position of the equation in native units. If given, this over-rides \code{at.npc}.
  }
  \item{varNames}{
    names to display for \code{x} and/or \code{y}.
    This should be a list
    like \code{list(y = "Q", x = "X")}
    or, for mathematical symbols,
    \code{alist(y = (alpha + beta), x = italic(sqrt(x[t])))}.
  }
  \item{varStyle}{
    the name of a \code{\link{plotmath}} function to wrap around the
    equation expression, or \code{NULL}. E.g. \code{"bolditalic"},
    \code{"displaystyle"}.
  }
  \item{digits}{
    number of decimal places to show for coefficients in equation.
  }
  \item{x, y}{
    data, passed on as \code{lm(y ~ x)}.
  }
}
\details{
  The equation is constructed as an expression using \code{\link{plotmath}}.
}
\author{
  Felix Andrews \email{felix@nfrac.org}
}
\seealso{
  \code{\link{panel.abline}},
  \code{\link{panel.text}},
  \code{\link{lm}},
  \code{\link{plotmath}}
}
\examples{
set.seed(0)
xsim <- rnorm(50, mean = 3)
ysim <- (0 + 2 * xsim) * (1 + rnorm(50, sd = 0.3))

## basic use as a panel function
xyplot(ysim ~ xsim, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)
  panel.lmlineq(x, y, adj = c(0, 1))
})

## using layers:
xyplot(ysim^2 ~ xsim) +
  layer(panel.ablineq(lm(y ~ x, subset = x <= 3),
    varNames = alist(y = y^2, x = x[x <= 3]), pos = 4))

## rotated equation (depends on device size *at time of plotting*)
xyplot(ysim ~ xsim) +
  layer(panel.ablineq(lm(y ~ x), rotate = TRUE, at.npc = 0.8))

## horizontal and vertical lines
xyplot(ysim ~ xsim) +
  layer(panel.ablineq(v = 3, pos = 4, at.npc = 0.1, lty = 2)) +
  layer(panel.ablineq(h = mean(ysim), pos = 3, at.npc = 0.15,
                      varNames = alist(y = plain(mean)(y)), lty = 2))

## using layer styles, r.squared
xyplot(ysim ~ xsim) +
  layer(panel.ablineq(lm(y ~ x), r.sq = TRUE, adj=c(0,1)), style = 1) +
  layer(panel.ablineq(lm(y ~ x + 0), r.sq = TRUE, adj=c(1,0)), style = 2)

update(trellis.last.object(),
  key = simpleKey(c("intercept", "no intercept"),
                  points = FALSE, lines = TRUE))
}
\keyword{ aplot }
