
panel.tskernel <-
    function(x, y, ...,
             m, c = 1, sides = 2, circular = FALSE,
             kern = kernel("daniell", rep(round(m / sqrt(c)), c)))
{
    if (!missing(y)) {
        if (diff(range(diff(x))) > getOption("ts.eps"))
            stop("'x' should be a regular series")
        x <- ts(y, start = x[1], end = tail(x,1), deltat = diff(x[1:2]))
    }
    x <- as.ts(x)
    i <- -kern$m:kern$m
    panel.lines(filter(x, kern[i], sides = sides, circular = circular), ...)
    #panel.lines(kernapply(x, kern, circular = circular), ...)
}
