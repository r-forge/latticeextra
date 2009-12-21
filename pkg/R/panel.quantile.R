
## based on the stat_quantile() function in ggplot2 package.

panel.quantile <-
    function(x, y, formula = y ~ x, method = "rq", ...,
             tau = 0.5, n = 100,
             ci = FALSE, ci.type = "default", level = 0.95,
             col = plot.line$col, col.se = col,
             lty = plot.line$lty, lwd = plot.line$lwd,
             alpha = plot.line$alpha,
             alpha.se = 0.25, border = NA,
             superpose = FALSE,
             ## ignored (do not pass to method()):
             subscripts, group.number, group.value,
             type, col.line, col.symbol, fill,
             pch, cex, font, fontface, fontfamily)
{
    library("quantreg")
    plot.line <- trellis.par.get("plot.line")
    if (all(is.na(col)) && !missing(col.line))
        col <- col.line
    if (is.character(method))
        method <- get(method, mode = "function")
    ## use 'x' and 'y' if given
    ## otherwise try to find them in the formula environment
    if (missing(x))
        x <- environment(formula)$x
    if (missing(y))
        y <- environment(formula)$y
    mod <- method(formula, tau = tau, data = list(x = x, y = y), ...)
    xseq <- seq(min(x), max(x), length = n)
    pred <- predict(mod, data.frame(x = xseq),
                    interval = if (ci) "confidence" else "none",
                    type = ci.type, level = level)
    pred <- as.matrix(pred)
    if (ci && ncol(pred) > 1) {
        panel.polygon(x = c(xseq, rev(xseq)),
                      y = c(pred[,"lower"], rev(pred[,"higher"])),
                      col = col.se, alpha = alpha.se, border = border)
        pred <- pred[, "fit", drop = FALSE]
    }
    if (superpose) {
        for (i in 1:NCOL(pred)) {
            line <- Rows(trellis.par.get("superpose.line"), i)
            panel.lines(xseq, pred[,i], col = line$col, alpha = line$alpha,
                        lty = line$lty, lwd = line$lwd)
        }
    } else {
        apply(pred, 2, panel.lines, x = xseq, col = col, alpha = alpha,
              lty = lty, lwd = lwd)
    }
}

## moving quantiles
#L.rollquantile <- function(probs = c(0.05, 0.5, 0.95), width,
#                           alpha = 0.25, ...)
#{
#    stopifnot(require("zoo"))
#    z <- zoo(y, x)
#    pred <- rollapply(z, width = width, quantile, probs = probs,
#                      na.rm = TRUE)
#    apply(pred, 2, panel.lines, x = time(pred), col = col)
#}

## quantile regression with smoothness by mgcv
#  L.quantile <- function(probs = c(0.05, 0.5, 0.95), n = 100,
#    alpha = 0.25, ss = FALSE, lambda = NULL, ...)
#  {
#      mod <- rqss(y ~ rqss(x), tau = probs, lambda = lambda)
