\name{layer}
\alias{layer}
\alias{layer_}
\alias{glayer}
\alias{glayer_}
\alias{+.trellis}
\alias{drawLayer}
\alias{flattenPanel}
\alias{[.layer}
\alias{print.layer}
\title{ Conveniently augment trellis objects }
\description{
  A mechanism to add new layers to a trellis object,
  optionally using a new data source.
  This works by adding arbitrary expressions to the panel function.
  It can simplify programmatic augmentation of trellis objects.
}
\usage{
layer(..., data, under, packets,
      rows, columns, groups,
      superpose, style, theme)

layer_(...)
glayer(...)
glayer_(...)

\S3method{+}{trellis}(object, lay)

drawLayer(lay)

flattenPanel(object)
}
\arguments{
  \item{\dots}{
    expressions as they would appear in a panel function.
    These can refer to the panel function arguments
    (typically \code{x}, \code{y} and \code{subscripts}), or
    alternatively \code{\dots}, which represents all panel function arguments.
    In addition, \code{data} is used as the evaluation frame.
  }
  \item{data}{
    an optional data source (\code{data.frame}, \code{environment}, etc:
    see \code{\link{eval}}) used when evaluating (drawing) the layer.
  }
  \item{under}{
    whether the layer should be drawn before the existing panel
    function. This defaults to \code{TRUE} in the convenience functions
    \code{layer_()} and \code{glayer_()}.
  }
  \item{packets, rows, columns, groups}{
    restricts the layer to draw only in specified packets (which refer
    to individual panels, but are independent of their layout), or rows
    or columns of the trellis layout.
    See \code{\link{trellis.currentLayout}}.

    For group layers (using \code{glayer} or \code{superpose = TRUE}),
    the groups can be restricted also, by number.
  }
  \item{superpose}{
    if \code{TRUE}, the layer will be drawn once for
    each level of any \code{groups} in the plot, using
    \code{\link{panel.superpose}}. This defaults to \code{TRUE} in the
    convenience functions \code{glayer()} and \code{glayer_()}.
  }
  \item{style}{
    style index of the layer, used only to set lattice graphical
    parameters (same effect as in grouped displays).
  }
  \item{theme}{
    a style specification to be passed to \code{\link{trellis.par.set}}.
  }
  \item{object}{ a trellis object. }
  \item{lay}{ a layer object. }
}
\details{
  The \code{layer} mechanism is an alternative method for
  augmenting a panel function. It allows expressions to be added to the
  panel function without knowing what the original panel function
  was. In this way it can be useful for quick augmentation of trellis
  plots.

  A typical example would be adding a reference line
  to each panel: \code{layer(panel.refline(h = 0))}. Note that the
  expressions are quoted, so if you have local variables they
  will need to be accessible globally, or passed in via the \code{data}
  argument:
  \code{layer(panel.refline(h = myVal), data = list(myVal = myVal))}.
%  Alternatively,
%  \code{eval(bquote( layer(panel.refline(h = .(myVal))) ))}.

  \code{layer()} should probably still be considered experimental.

  \code{drawLayer()} actually draws the given layer object, applying the
  panel specification, style settings and so on. It should only be
  called while a panel is in focus.

  The \code{flattenPanel} function will construct a human-readable
  function incorporating code from all layers (and the original panel
  function). Note that this does not return a usable function, as it
  lacks the correct argument list and ignores any extra data sources
  that layers might use. It is intended be edited manually.
}
\value{
  a \code{layer} object is defined as a list of expression objects,
  each of which may have a set of attributes. The result of "adding"
  a layer to a trellis object (\code{+.trellis}) is the updated trellis
  object.
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{
  \code{\link[lattice]{update.trellis}},
  \code{\link{as.layer}} for overlaying entire plots
}
\examples{
foo <- xyplot(ozone ~ wind, environmental)
foo

## overlay reference lines
foo <- foo + layer(panel.abline(h = 0)) +
             layer(panel.lmline(x, y, lty = 2))

## underlay a flat colour
foo <- foo + layer(panel.fill(grey(.98)), under = TRUE)
foo

## layers can access the panel function arguments
foo <- foo + layer({ ok <- (y>100);
            panel.text(x[ok], y[ok], y[ok], pos = 1) })
foo

## see a sketch of the complete panel function
flattenPanel(foo)


## group layers, drawn for each group in each panel
dotplot(VADeaths, type = "o") +
glayer(ltext(x[5],y[5],colnames(VADeaths)[group.number],srt=40))

## a quick way to inspect the panel.groups arguments:
dotplot(VADeaths, type = "o") + glayer(str(list(...)))


## layers with superposed styles
zoip <- xyplot(ozone ~ wind | equal.count(temperature, 2),
        data = environmental) +
   layer(panel.loess(x, y, span = 0.5), style = 1) +
   layer(panel.loess(x, y, span = 1.0), style = 2)
update(zoip, key = simpleKey(c("span = 0.5", "span = 1.0"),
   title = "loess smooth", lines = TRUE, points = FALSE))

## using other variables from the original `data` object
## NOTE: need subscripts = TRUE in original call!
zoip <- xyplot(wind ~ temperature | equal.count(radiation, 2),
   data = environmental, subscripts = TRUE)
zoip + layer(panel.points(..., pch = 19,
             col = grey(1 - ozone[subscripts] / max(ozone))),
       data = environmental)


## restrict drawing to specified panels
barchart(yield ~ variety | site, data = barley,
         groups = year, layout = c(1,6), as.table = TRUE,
         scales = list(x = list(rot = 45))) +
layer(ltext(tapply(y, x, max), lab = abbreviate(levels(x)),
      pos = 3), rows = 1)


## example of a new data source
qua <- xyplot(lat ~ long | cut(depth, 2), quakes,
    aspect = "iso", pch = ".", cex = 2)
qua
## add layer showing distance from Auckland
newdat <- with(quakes, expand.grid(
            gridlat = seq(min(lat), max(lat), length = 60),
            gridlon = seq(min(long), max(long), length = 60)))
newdat$dist <- with(newdat, sqrt((gridlat - -36.87)^2 +
                                 (gridlon - 174.75)^2))
qua + layer_(panel.contourplot(gridlon, gridlat, dist,
   contour = TRUE, subscr = TRUE), data = newdat)
}
\keyword{ aplot }
