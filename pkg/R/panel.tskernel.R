
panel.tskernel <-
    function(x, y, ...,
             width, c = 1, sides = 2, circular = FALSE,
             kern = kernel("daniell", rep(floor((width/sides)/sqrt(c)), c)))
{
    if (!missing(y)) {
        if (diff(range(diff(x))) > getOption("ts.eps"))
            stop("'x' should be a regular series")
        x <- ts(y, start = x[1], end = tail(x,1), deltat = diff(x[1:2]))
    }
    x <- as.ts(x)
    if (sides == 2) {
        i <- -kern$m:kern$m
        filter <- kern[i]
    } else if (sides == 1) {
        i <- -kern$m:0
        filter <- kern[i] / sum(kern[i])
    } else stop("unrecognised value of 'sides'")
    panel.lines(filter(x, filter, sides = sides, circular = circular), ...)
}
