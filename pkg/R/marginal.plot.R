##
## Copyright (c) 2007 Felix Andrews <felix@nfrac.org>
## GPL version 2 or newer

is.categorical <- function (x)
{
    is.factor(x) || is.shingle(x) || is.character(x) || is.logical(x)
}

marginal.plot <-
    function(data,
             groups = NULL,
             reorder = TRUE,
             plot.points = FALSE,
             ref = TRUE,
             origin = 0,
             xlab = NULL, ylab = NULL,
             cex = 0.6,
             type = c("p", if (is.null(groups)) "h"),
             ...,
             subset = TRUE,
             as.table = TRUE,
             subscripts = TRUE,
             default.scales = list(
               x = list(relation = "free", abbreviate = TRUE,
                 rot = 60, cex = 0.5, tick.number = 3),
               y = list(relation = "free", draw = FALSE)))
{
    if (!is.data.frame(data))
        data <- as.data.frame(data)
    nvar <- ncol(data)
    iscat <- sapply(data, is.categorical)
    ## groups and subset are subject to non-standard evaluation:
    ## evaluate in context of data, or if that fails just eval as usual
    ## (because latticist uses: subset = complete.cases(dat))
    ## evaluate groups
    if (!missing(groups)) {
        tmp <- try(eval(substitute(groups), data), silent = TRUE)
        if (!inherits(tmp, "try-error")) groups <- tmp
    }
    ## apply subset
    if (!missing(subset)) {
        tmp <- try(eval(substitute(subset), data), silent = TRUE)
        if (!inherits(tmp, "try-error")) subset <- tmp
        if (!isTRUE(subset)) data <- data[subset,]
    }
    ## reorder factor levels
    if (reorder) {
        for (nm in names(data)[iscat]) {
            val <- data[[nm]]
            if (is.character(val))
                data[[nm]] <- factor(val)
            if (!is.ordered(val) &&
                !is.shingle(val) &&
                nlevels(val) > 1)
            {
                data[[nm]] <- reorder(val, val, function(z) -length(z))
            }
        }
    }
    if (any(iscat)) {
        ## list of dotplot objects
        dotobjs <- lapply(data[iscat],
                          function(x) {
                              if (!is.null(groups)) {
                                  tab <- table(Value = x, groups = groups)
                              } else {
                                  tab <- table(Value = x)
                              }
                              dotplot(tab, horizontal = FALSE,
                                      groups = !is.null(groups),
                                      subscripts = TRUE,
                                      ...,
                                      type = type, cex = cex,
                                      origin = origin,
                                      as.table = as.table,
                                      default.scales = default.scales,
                                      xlab = xlab, ylab = ylab)
                          })
        ## TODO: index.cond? maybe better to keep original order of vars
        ## merge the list of trellis objects into one
        factobj <- do.call("c", dotobjs)
        ## set strip name if only one panel
        if (prod(dim(factobj)) == 1)
            rownames(factobj) <- names(data)[iscat]
        factobj$call <- match.call()
        if (all(iscat)) return(factobj)
    }
    if (any(!iscat)) {
        ## construct formula with all numeric variables
        numform <- paste("~", paste(names(data)[!iscat], collapse = " + "))
        numform <- as.formula(numform)
        numobj <-
            densityplot(numform, data, outer = TRUE,
                        subscripts = TRUE,
                        groups = groups,
                        ...,
                        plot.points = plot.points, ref = ref,
                        as.table = as.table,
                        default.scales = default.scales,
                        xlab = xlab, ylab = ylab)
        ## set strip name if only one panel
        if (prod(dim(numobj)) == 1)
            rownames(numobj) <- names(data)[!iscat]
        ## TODO: index.cond?
        ## order packets by mean, same effect as index.cond
        #numdat$which <- with(numdat, reorder(which, data, mean, na.rm = TRUE))
        numobj$call <- match.call()
        if (all(!iscat)) return(numobj)
    }
    ## if there are both categoricals and numerics,
    ## merge the trellis objects
    obj <- c(factobj, numobj)
    obj$call <- match.call()
    obj
}
