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
\title{ Add layers to a Trellis plot, optionally using a new data source }
\description{
  A mechanism to add new layers to a trellis object, optionally using a
  new data source. This is an alternative to modifying the
  panel function. Note the non-standard evaluation used in \code{layer()}!
}
\usage{
layer(..., data, eval, etc,
      packets, rows, columns, groups,
      under, superpose, style, theme)

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
    \strong{alternatively} the special argument \dQuote{\code{\dots}},
    which represents all panel function arguments. 
    In addition, \code{data}, if given, is used as the evaluation frame.
    See also the discussion under Details, below.
  }
  \item{data}{
    optional. A named \code{list} containing objects needed when
    evaluating (drawing) the layer.
  }
  \item{eval}{
    if \code{eval = TRUE}, arguments given in the layer code will be
    evaluated  immediately (in the calling environment). This makes it
    easier to pass in values from local variables. This should only be
    used when the layer code consists of simple top-level function calls
    (e.g. no \code{if} statements or \code{\{braces\}}).
    The default is \code{eval = FALSE}.

    When \code{eval = TRUE}, you can not directly refer to the panel
    function internal variables such as \code{x} and \code{y} (because
    they would be interpreted as local variables in your calling frame),
    but see the \code{etc} argument for a way around this.
    % DEPRECATED:
    %Instead you can use the
    %special names \code{.x}, \code{.y}, \code{.z}, \code{.subscripts}
    %and \code{.groups}.
  }
  \item{etc}{
    The \code{etc} argument can be used to pass the panel function
    internal variables through to the call inside \code{layer()}, while
    allowing some of these to be replaced or omitted. If none of the
    internal variables are to be replaced or omitted, then one can
    simply use the \dQuote{\dots}, as in
    \code{layer(panel.xyplot(...))}.  If \code{etc = TRUE} then all
    remaining (un-named) panel function arguments are passed through. If
    \code{etc} is a character vector then only those named arguments are
    passed through.  For example, to over-ride the \code{type} argument
    in a layer: \code{layer(panel.xyplot(type = "h"), etc = TRUE)}. This
    passes through all the arguments except \code{type} from
    \dQuote{\code{\dots}}.
    
    The \code{etc} argument can be used with \code{eval = TRUE},
    allowing access to the panel function internal variables. For
    example, to pass through an argument by value from the current
    frame, while also passing on the internal \code{x} argument:
    \code{layer(panel.lines(y = myFancyY), eval = TRUE, etc = "x")}.
  }
  \item{packets, rows, columns, groups}{
    restricts the layer to draw only in specified packets (which refer
    to individual panels, but are independent of their layout), or rows
    or columns of the trellis layout (\code{\link{trellis.currentLayout}}).
    For group layers (using \code{glayer} or \code{superpose = TRUE}),
    the groups can be restricted also, by specifying group numbers (or
    group values, as character strings). Negative values exclude the
    given items. 
  }
  \item{superpose}{
    if \code{TRUE}, the layer will be drawn once for
    each level of any \code{groups} in the plot, using
    \code{\link{panel.superpose}}. This defaults to \code{TRUE} in the
    convenience functions \code{glayer()} and \code{glayer_()}.
  }
  \item{under}{
    whether the layer should be drawn before the existing panel
    function. This defaults to \code{TRUE} in the convenience functions
    \code{layer_()} and \code{glayer_()}.
  }
  \item{style}{
    style index of the layer, used only to set lattice graphical
    parameters (same effect as in grouped displays).
  }
  \item{theme}{
    a style specification to be passed to \code{\link{trellis.par.set}}
    which has effect only while drawing the layer.
  }
  \item{object}{ a trellis object. }
  \item{lay}{ a layer object. }
}
\details{
  The \code{layer} mechanism is a method for augmenting a panel
  function. It allows expressions to be added to the
  panel function without knowing what the original panel function
  was. In this way it can be useful for quick augmentation of trellis
  plots.

  Note that the evaluation used in \code{layer} is non-standard, and can
  be confusing at first: you typically refer to variables as if inside
  the panel function (\code{x}, \code{y}, etc); you can usually refer to
  objects which exist in the global environment (workspace), but it is
  safer to pass them in by name in the \code{data} argument to
  \code{layer}. (This is not to be confused with the \code{data} argument
  to the original \code{xyplot}.)

  A simple example is adding a reference line
  to each panel: \code{layer(panel.refline(h = 0))}. Note that the
  expressions are quoted, so if you have local variables they
  will need to be either (a) accessible globally, or (b) evaluated using
  the argument \code{eval = TRUE}, or (c) passed in via
  the \code{data} argument For example:

  \code{layer(panel.refline(h = myVal)) ## if myVal is global}

  \code{layer(panel.refline(h = h), eval = TRUE)}

  \code{layer(panel.refline(h = h), data = list(h = myVal))}

  The layer mechanism should probably still be considered experimental.

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

## underlay a flat color
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
  glayer(ltext(x[5],y[5],group.value,srt=40))

## a quick way to print out the panel.groups arguments:
dotplot(VADeaths, type = "o") + glayer(str(list(...)))


## layers with superposed styles
zoip <- xyplot(ozone ~ wind | equal.count(temperature, 2),
        data = environmental) +
   layer(panel.loess(x, y, span = 0.5), style = 1) +
   layer(panel.loess(x, y, span = 1.0), style = 2)
update(zoip, auto.key = list(text = c("span = 0.5", "span = 1.0"),
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
\dontshow{ .featured_example <- TRUE }
## add layer showing distance from Auckland
newdat <- with(quakes, expand.grid(
            gridlat = seq(min(lat), max(lat), length = 60),
            gridlon = seq(min(long), max(long), length = 60)))
newdat$dist <- with(newdat, sqrt((gridlat - -36.87)^2 +
                                 (gridlon - 174.75)^2))
qua + layer_(panel.contourplot(x = gridlon, y = gridlat, z = dist,
   contour = TRUE, subscripts = TRUE), data = newdat)
}
\keyword{ aplot }
