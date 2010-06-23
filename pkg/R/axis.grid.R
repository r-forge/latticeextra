

axis.grid <-
    function(side = c("top", "bottom", "left", "right"),
             scales, components, ..., line.col)
{
    side <- match.arg(side)
    if (is.list(components[[side]])) { ## not on right/top sides
        scales.tck <- switch(side,
                             left = , bottom = scales$tck[1], 
                             right = , top = scales$tck[2])
        ## only draw major ticks (those corresponding to labels)
        comps.major <- components
        tck <- components[[side]]$ticks$tck
        lab <- components[[side]]$labels$labels
        if (any(lab != "")) {
            if (any(tck * scales.tck != 0)) {
                tck <- rep(tck, length = length(lab))
                comps.major[[side]]$ticks$tck <- ifelse(lab == "", NA, tck)
            }
            ## use axis.text for ticks because axis.line$col might be transparent
            axis.text <- trellis.par.get("axis.text")
            axis.default(side, scales = scales,
                         components = comps.major, ...,
                         line.col = axis.text$col)
        }
    }
    ## now draw grid lines corresponding to axis ticks.
    ## can only do this with the bottom and right sides;
    ## otherwise the strip viewports are current, not panel.
    if (side %in% c("top", "left"))
        return()
    if (scales$draw == FALSE)
        return()
    ref.line <- trellis.par.get("reference.line")
    if (side == "bottom") {
        comp.list <- components[["bottom"]]
        tck <- abs(comp.list$ticks$tck)
        panel.refline(v = comp.list$ticks$at, 
                      lwd = ref.line$lwd * tck,
                      alpha = ref.line$alpha * tck / max(tck, na.rm = TRUE))
    }
    if (side == "right") {
        comp.list <- components[["left"]] ## "left" is main component
        tck <- abs(comp.list$ticks$tck)
        panel.refline(h = comp.list$ticks$at, 
                      lwd = ref.line$lwd * tck,
                      alpha = ref.line$alpha * tck / max(tck, na.rm = TRUE))
    }
}
