## Copyright (c) 2009 Felix Andrews <felix@nfrac.org>


panel.ablineq <-
    function(a = NULL, b = 0,
             h = NULL, v = NULL,
             reg = NULL, coef = NULL,
             pos = if (rotate) 1, offset = 0.5, adj = NULL,
             fontfamily = "serif",
             rotate = FALSE, srt = 0,
             r.squared = FALSE,
             ...,
             at.npc = 0.5,
             at.x = NULL, at.y = NULL,
             varNames = alist(y = y, x = x),
             varStyle = "italic",
             digits = 3, sep = ", ", sep.end = "")
{
    ## draw the line
    panel.abline(a = a, b = b, h = h, v = v, reg = reg, coef = coef, ...)
    ## extract r.squared from model object if any
    if (!is.null(reg)) {
        a <- reg
    }
    if (isTRUE(r.squared)) {
        if (is.object(a) || is.list(a)) {
            r.squared <- round(summary(a)$r.squared, digits)
        } else {
            warning("r.squared = TRUE requires a model object")
        }
    }
    ## work out equation coefficients
    ## the following copied from lattice::panel.abline
    if (is.object(a) || is.list(a)) {
        p <- length(coefa <- as.vector(coef(a)))
        if (p > 2)
            warning("only using the first two of ", p, "regression coefficients")
        islm <- inherits(a, "lm")
        noInt <- if (islm)
            !as.logical(attr(stats::terms(a), "intercept"))
        else p == 1
        if (noInt) {
            a <- 0
            b <- coefa[1]
        }
        else {
            a <- coefa[1]
            b <- if (p >= 2)
                coefa[2]
            else 0
        }
    }
    if (!is.null(coef)) {
        if (!is.null(a))
            warning("'a' and 'b' are overridden by 'coef'")
        a <- coef[1]
        b <- coef[2]
    }
    if (length(h <- as.numeric(h)) > 0) {
        if (!is.null(a))
            warning("'a' and 'b' are overridden by 'h'")
        a <- h[1]
        b <- 0
    }
    if (length(a) > 1) {
        b <- a[2]
        a <- a[1]
    }
    ## construct the equation label
    if (length(as.numeric(v)) > 0) {
        ## vertical line (special case)
        if (!is.null(a))
            warning("'a' and 'b' are overridden by 'v'")
        at.x <- v[1]
        if (is.null(at.y))
            at.y <- convertY(unit(at.npc, "npc"), "native", TRUE)
        v <- signif(v[1], digits)
        varNames <- c(as.list(varNames), v = v)
        lab <- substitute(x == v, varNames)
        if (rotate) srt <- 90
    } else {
        ## normal a+bx line
        if (is.null(at.x))
            at.x <- convertX(unit(at.npc, "npc"), "native", TRUE)
        if (is.null(at.y))
            at.y <- a + b * at.x
        a <- round(a, digits)
        b <- round(b, digits)
        varNames <- c(as.list(varNames), a = a, b = b)
        if (b == 0) {
            lab <- substitute(y == a, varNames)
        } else if (a == 0) {
            lab <- substitute(y == b * x, varNames)
        } else if (b > 0) {
            lab <- substitute(y == a + b * x, varNames)
        } else {
            varNames$b <- abs(b)
            lab <- substitute(y == a - b * x, varNames)
        }
        if (rotate) {
            ## aspect ratio with respect to native coordinates
            asp <- with(lapply(current.panel.limits(), diff), ylim / xlim)
            ## aspect ratio of panel at *current* device size
            asp.cm <- with(lapply(current.panel.limits("cm"), diff), ylim / xlim)
            grad <- b * (asp.cm / asp)
            srt <- 180 * atan(grad) / pi
        }
    }
    if (is.numeric(r.squared)) {
        ## add R^2 = ... to label
        r.expr <- substitute(italic(R)^2 == z,
                            list(z = r.squared))
        lab <- call("paste", lab, sep, r.expr, sep.end)
    }
    if (!is.null(varStyle)) {
        while (length(varStyle) > 0) {
            lab <- call(varStyle[1], lab)
            varStyle <- varStyle[-1]
        }
    }
    panel.text(at.x, at.y, lab, pos = pos, offset = offset, adj = adj,
               fontfamily = fontfamily, srt = srt, ...)
}

panel.lmlineq <-
    function(x, y, ...)
{
    if (length(x) > 1)
        panel.ablineq(lm(as.numeric(y) ~ as.numeric(x)), ...)
}

