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
    iscat <- sapply(data, is.categorical)
    ## groups and subset are subject to non-standard evaluation:
    groups <- eval(substitute(groups), data)
    if (!missing(subset)) {
        ## need this for e.g.
        ## evalq(marginal.plot(dat, subset = complete.cases(dat)), myEnv)
        tmp <- try(eval(substitute(subset), data), silent = TRUE)
        if (!inherits(tmp, "try-error")) subset <- tmp
    }
    ## apply subset
    if (!isTRUE(subset)) data <- data[subset,]
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
        ## handle categorical variables
        ## make a list of dotplot trellis objects
        dotobjs <- lapply(data[iscat],
                          function(x)
                      {
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
        ## TODO: index.cond? or maybe better to keep original order of vars
        ## merge the list of trellis objects into one
        factobj <- do.call("c", dotobjs)
        ## set strip name if only one panel
        if (prod(dim(factobj)) == 1)
            rownames(factobj) <- names(data)[iscat]
        factobj$call <- match.call()
        if (all(iscat)) return(factobj)
    }
    if (any(!iscat)) {
        ## handle numeric variables
        ## construct formula with all numeric variables
        numform <- paste("~", paste(names(data)[!iscat],
                                    collapse = " + "))
        numobj <-
            densityplot(as.formula(numform), data, outer = TRUE,
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
        numobj$call <- match.call()
        if (all(!iscat)) return(numobj)
    }
    ## if there are both categoricals and numerics,
    ## merge the trellis objects
    obj <- c(factobj, numobj)
    obj$call <- match.call()
    obj
}
