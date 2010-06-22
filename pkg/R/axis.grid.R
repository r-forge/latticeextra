

axis.grid <-
    function(side = c("top", "bottom", "left", "right"),
             scales, components, ...)
{
    side <- match.arg(side)
    axis.default(side, scales = scales, components = components, ...)
    ## now draw grid lines corresponding to axis ticks.
    ## can only do this with the bottom and right sides;
    ## otherwise the strip viewports are current, not panel.
    if (side %in% c("top", "left"))
        return()
    if (scales$draw == FALSE)
        return()
    reflwd <- trellis.par.get("reference.line")$lwd
    if (side == "bottom") {
        comp.list <- components[["bottom"]]
        panel.refline(v = comp.list$ticks$at, 
                     lwd = reflwd * comp.list$ticks$tck)
    }
    if (side == "right") {
        comp.list <- components[["left"]] ## "left" is main component
        panel.refline(h = comp.list$ticks$at, 
                     lwd = reflwd * comp.list$ticks$tck)
    }
}
