

horizonplot <- function(x, data, ...)
    UseMethod("horizonplot")

horizonplot.default <-
    function(x, data = NULL, ...,
             panel = panel.horizonplot,
             prepanel = prepanel.horizonplot,
             strip = FALSE, groups = NULL, 
             layout = c(1, Inf),
             default.scales = list(y = list(relation = "sliced")))
{
    stopifnot(is.null(data))
    if (!is.null(groups))
        stop("'groups' does not work in this plot")
    ans <- xyplot(x, ..., panel = panel, prepanel = prepanel,
                  strip = strip,
                  layout = layout,
                  default.scales = default.scales)
    ans$call <- match.call()
    ans
}


panel.horizonplot <-
    function(x, y, ..., origin,
             border = NA, col.regions = regions$col)
{
    regions <- trellis.par.get("regions")
    origin <- current.panel.limits()$y[1]
    #if (is.function(origin))
    #    origin <- origin(y)
    #scale <- max(abs(range(y, finite = TRUE) - origin)) / 3
    scale <- diff(current.panel.limits()$y)
    ## ordered for drawing, from least extreme to most extreme
    sections <- c(-1, 0, -2, 1, -3, 2, -4, 3) ## these are the lower bounds
    #ycut <- cut(y, breaks = c(-Inf, breaks, Inf))
    ii <- quantile(seq_along(col.regions),
                   (sections - min(sections)) / (length(sections)-1),
                   type = 1)
    #col <- col.regions[1 + (length(col.regions)-1) * 0:5/5]
    col <- col.regions[ii]
    for (i in seq_along(sections)) {
        section <- sections[i]
        yi <- y
        if (section < 0) {
            yi <- origin + origin - y
            section <- abs(section) - 1
        }
        baseline <- origin + section * scale
        if (all(yi <= baseline, na.rm = TRUE))
            next
        yi <- yi - baseline
        yi <- origin + pmax(pmin(yi, scale), 0)
        panel.xyarea(x, yi, border = border, col = col[i], ...)
    }
}

prepanel.horizonplot <-
    function(x, y, ..., origin = function(y) na.omit(y)[1])
{
    if (is.function(origin))
        origin <- origin(y)
    ans <- prepanel.default.xyplot(x, y, ...)
    scale <- max(abs(ans$ylim - origin)) / 3
    ans$ylim <- origin + c(0, scale)
    ans
}
