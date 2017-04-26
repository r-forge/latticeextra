
## Similar to panel.xyplot, except that (x,y) data are indicated by an
## image rather than standard plotting character. The image URLs must
## be provided by 


## Support only png and jpeg for now.

url2raster <- function(src)
{
    ext <- tail(strsplit(src, split = ".", fixed = TRUE)[[1]], 1)
    if (file.exists(src)) file <- src
    else 
    {
        file <- tempfile(fileext = paste0(".", ext))
        download.file(src, destfile = file, mode = "wb", quiet = TRUE)
        on.exit(unlink(file))
    }
    readWith <- switch(ext,
                       png = list(readPNG, readJPEG),
                       list(readJPEG, readPNG))
    ## Try best guess first. If it fails, try the other
    r <- try(readWith[[1]](file, native = TRUE), silent = TRUE)
    if (inherits(r, "try-error"))
        r <- try(readWith[[2]](file, native = TRUE), silent = TRUE)
    if (inherits(r, "try-error"))
        stop("'%s' does not appear to be a PNG or JPEG file.", src)
    r
}


panel.xyimage <-
    function(x, y, 
             subscripts,
             groups = NULL,
             pch = NULL,
             cex = 1,
             ...,
             grid = FALSE, abline = NULL,
             identifier = "xyplot")
{
    if (all(is.na(x) | is.na(y))) return()
    if (!is.character(pch))
        stop("'pch' must be a character vector giving path(s) or URL(s) of PNG or JPEG files.")
    pch.raster <- lapply(pch, url2raster)
    if (!identical(grid, FALSE))
    {
        if (!is.list(grid))
            grid <- switch(as.character(grid),
                           "TRUE" = list(h = -1, v = -1, x = x, y = y),
                           "h" = list(h = -1, v = 0, y = y),
                           "v" = list(h = 0, v = -1, x = x),
                           list(h = 0, v = 0))
        do.call(panel.grid, grid)
    }
    if (!is.null(abline))
    {
        if (is.numeric(abline)) abline <- as.list(abline)
        do.call(panel.abline, abline)
    }
    if (is.null(groups))
        grid.raster(x, y, image = pch.raster[[1]],
                    width = unit(cex * 10, "mm"),
                    height = unit(cex * 10, "mm"),
                    default.units = "native")
    else
    {
        g <- as.numeric(groups)[subscripts]
        ug <- unique(g)
        pch.raster <- rep(pch.raster, length = length(ug))
        cex <- rep(cex, length = length(ug))
        for (i in ug)
        {
            w <- (g == i)
            grid.raster(x[w], y[w], image = pch.raster[[i]],
                        width = unit(cex[i] * 10, "mm"),
                        height = unit(cex[i] * 10, "mm"),
                        default.units = "native")
        }
    }
    
}


