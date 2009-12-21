
## based on the stat_smooth() function in ggplot2 package.

panel.smoother <-
    function(x, y, formula = y ~ x, method = "loess", ...,
             se = TRUE, level = 0.95, n = 100,
             col = plot.line$col, col.se = col,
             lty = plot.line$lty, lwd = plot.line$lwd,
             alpha = plot.line$alpha,
             alpha.se = 0.25, border = NA,
             ## ignored (do not pass to method()):
             subscripts, group.number, group.value,
             type, col.line, col.symbol, fill,
             pch, cex, font, fontface, fontfamily)
{
    plot.line <- trellis.par.get("plot.line")
    if (all(is.na(col)) && !missing(col.line))
        col <- col.line
    if (is.character(method))
        method <- get(method, mode = "function")
    ## allow 'formula' to be passed as the first argument
    missing.x <- missing(x)
    if (!missing.x && inherits(x, "formula")) {
        formula <- x
        missing.x <- TRUE
    }
    ## use 'x' and 'y' if given
    ## otherwise try to find them in the formula environment
    if (missing.x)
        x <- environment(formula)$x
    if (missing(y))
        y <- environment(formula)$y
    #data <- list()
    #data$x <- if (!missing(x)) x
    #data$y <- if (!missing(y)) y
    mod <- method(formula, data = list(x = x, y = y), ...)
    xseq <- seq(min(x), max(x), length = n)
    pred <- predict(mod, data.frame(x = xseq), se = se)
    if (se) {
        std <- qnorm(level/2 + 0.5)
        panel.polygon(x = c(xseq, rev(xseq)),
                      y = c(pred$fit - std * pred$se,
                      rev(pred$fit + std * pred$se)),
                      col = col.se, alpha = alpha.se, border = border)
        pred <- pred$fit
    }
    panel.lines(xseq, pred, col = col, alpha = alpha,
                lty = lty, lwd = lwd)
    #do.call("panel.lines", c(list(x = xseq, y = pred),
    #                         trellis.par.get("add.line")))
}
