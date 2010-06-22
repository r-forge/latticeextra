

## based on some of the default themes and scales used in ggplot2 by Hadley Wickham.

ggplot2like.theme <-
    function(..., n = 6, h = c(0,360) + 15, l = 65, c = 100,
             h.start = 0, direction = 1,
             low = "#3B4FB8", high = "#B71B1A", space = "rgb")
{
    ## copied from ggplot2::scale_colour_hue
    rotate <- function(x) (x + h.start) %% 360 * direction
    if ((diff(h) %% 360) < 1) {
        h[2] <- h[2] - 360 / n
    }
    colseq <-
        hcl(h = rotate(seq(h[1], h[2], length = n)), c = c, l = l)
    ## copied from ggplot2::scale_colour_gradient
    ramp  <- colorRampPalette(c(low, high), space = space, interpolate = "linear")(100)
    theme <- custom.theme(symbol = colseq,
                          fill = colseq,
                          region = ramp)
    ## based on ggplot2::theme_gray
    theme <-
        modifyList(theme,
                   list(axis.line = list(col = "transparent"),
                        axis.text = list(cex = 0.8, lineheight = 0.9, col = "grey50"),
                        panel.background = list(col = "grey90"),
                        reference.line = list(col = "white", lwd = 2),
                        strip.background = list(col = c("grey80", "grey70", "grey60")),
                        add.text = list(cex = 0.8))
                   )
    ## misc
    theme <-
        modifyList(theme,
                   list(plot.symbol = list(col = "black", pch = 19, cex = 0.6),
                        superpose.symbol = list(pch = 19, cex = 0.6),
                        plot.line = list(col = "black"),
                        plot.polygon = list(col = "grey20", border = "transparent"),
                        superpose.polygon = list(border = "transparent"),
                        box.dot = list(col = "grey20", pch = "|"),
                        box.rectangle = list(fill = "white", col = "grey20"),
                        box.umbrella = list(col = "grey20", lty = 1))
                   )
    ## custom over-rides
    modifyList(theme, simpleTheme(...))
}
