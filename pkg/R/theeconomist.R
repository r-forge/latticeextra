## Implementation Copyright (c) 2009 Felix Andrews
## based on plot style used in The Economist magazine.


asTheEconomist <-
    function(x,
             type = "l",
             vertical = FALSE, zeroline = "red",
             par.settings = theEconomist.theme(with.bg = with.bg),
             with.bg = FALSE,
             titleSpec = list(x = grid::unit(5, "mm"), just = "left"),
             ylab = expression(NULL),
             xlab = expression(NULL),
             scales = list(axs = "i",
                 x = list(tck = 0, alternating = 1),
                 y = list(tck = 0, alternating = 2)),
             par.strip.text = list(font = 2),
             between = list(x = 1, y = 1))
{
    ans <- x
    ## make nice left-aligned title
    title <- ans$main
    if (is.null(title)) title <- ans$ylab
    if (is.null(title)) title <- ans$ylab.default
    if (!is.list(title)) title <- list(label = title)
    ans <- update(ans, main = modifyList(title, titleSpec))
    if (!is.null(ans$sub)) {
        sub <- ans$sub
        if (!is.list(sub)) sub <- list(sub)
        ans <- update(ans, sub = modifyList(sub, titleSpec))
        ## would like to have 'sub' above plot (below main)
        ## can't do it with a frameGrob because we lose the lattice style.
#            subGrob <- do.call(textGrob, modifyList(sub, titleSpec))
#            mainGrob <- do.call(textGrob, modifyList(title, titleSpec))
#            titleGrob <- frameGrob(name = "titleFrame")
#            titleGrob <- packGrob(titleGrob, mainGrob, side = "top")
#            titleGrob <- packGrob(titleGrob, subGrob, side = "bottom")
#            ans <- update(ans, main = titleGrob,
#                          sub = expression(NULL))
    }
    ans <- update(ans,
                  type = type, ylab = ylab, xlab = xlab,
                  par.settings = par.settings,
                  scales = scales,
                  par.strip.text = par.strip.text,
                  between = between)
    ans <- ans +
        eval(bquote(layer_(panel.xticksgrid(vertical = .(vertical),
                                            zeroline = .(zeroline)))))
    ans$call <- match.call()
    ans
}


theEconomist.theme <-
   function(win.fontfamily = "Gill Sans MT", fontfamily = "sans",
            with.bg = FALSE, box = "transparent")
{
    if (.Platform$OS.type == "windows") {
        windowsFonts(TheEconomistLike = win.fontfamily)
        fontfamily <- "TheEconomistLike"
    } else {
        ## TODO: how do fonts work on linux etc?
    }
    list(
         background = list(col = if (with.bg) "#D5E2E9" else "transparent"),
         plot.line = list(col = "#00526D", lwd = 2.5),
         superpose.line = list(col = c("#00526D", "#00A3DB", "#7A2713", "#939598", "#6CCFF6"), lwd = 2.5),
         plot.symbol = list(col = "#00526D", pch = 16, cex = 1.1),
         superpose.symbol = list(col = c("#00526D", "#00A3DB", "#7A2713", "#939598", "#6CCFF6"), pch = 16, cex = 1.1),
         plot.polygon = list(col = "#00526D"),
         superpose.polygon = list(col = c("#5F92A8", "#00526D", "#6CCFF6", "#00A3DB", "#A7A9AC")),
         reference.line = list(col = if (with.bg) "white" else "#aaaaaa", lwd = 1.75),
         dot.line = list(col = if (with.bg) "white" else "#aaaaaa", lwd = 1.75),
         add.line = list(col = "#ED1C24", lwd = 1.5),
         axis.line = list(col = box),
         box.3d = list(col = box),
         strip.border = list(col = box),
         strip.background = list(col = if (with.bg) "white" else "#CBDDE6"),
         strip.shingle = list(col = if (with.bg) "#CBDDE6" else "white", alpha = 0.5),
         par.main.text = list(font = 1),
         par.sub.text = list(font = 1),
         axis.text = list(cex = 1),
         grid.pars = list(fontfamily = fontfamily)
         )
}

panel.xticksgrid <-
    function(..., vertical = FALSE, zeroline = "red")
{
    lims <- current.panel.limits()
    xminor <- pretty(lims$x, n = 25)
    if (vertical) {
        panel.grid(h = 0, v = -1)
        if (abs(lims$x[1]) > abs(diff(lims$x)) / 20)
            panel.refline(v = 0, col = zeroline, alpha = 0.8)
    } else {
        panel.grid(h = -1, v = 0)
        if (abs(lims$y[1]) > abs(diff(lims$y)) / 20)
            panel.refline(h = 0, col = zeroline, alpha = 0.8)
    }
    panel.abline(h = lims$y[1], col = "black")
    panel.axis(side = "bottom", outside = TRUE,
               tck = -1, line.col = 1)
    panel.axis(side = "bottom", outside = TRUE,
               at = xminor, tck = -0.33, line.col = 1)
}
