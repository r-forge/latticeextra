# setwd("X:/Packages/latticeextra/www")

library(latticeExtra)
library(grid)
library(Cairo)

baseLink <- "http://bm2.genes.nig.ac.jp/RGM2/R_current/library/latticeExtra/man/"

## we want to be able to run example() for each function
## but only to keep *one* of the plots produced
## (specified by number).

## the following approach will only work if the examples
## don't include post-plotting annotations, or grid.new etc.

## global variables:
.plotNumber <- 0
.plotName <- NA
target <- NA

dev.new()
dummydev <- dev.cur()

## set the lattice print function to keep a counter.
lattice.options(print.function = function(x, ...) {
    .plotNumber <<- .plotNumber + 1
    message("  plot number ", .plotNumber)
    if (.plotNumber == target) {
        plot(x, ...)
        ## label the plot with function name etc (version number?)
        #pushViewport(viewport(xscale = c(0, 1),
        #                      yscale = c(0, 1)))
        #panel.text(x = 0.01, y = 1,
        #           lab = sprintf("(latticeExtra) %s",
        #                         .plotName, .plotNumber),
        #           adj = c(0, 1.5))
        ## stop the example() call - avoid any base plots following
        stop("target plot completed; stopping (OK)")
    } else {
        ## plot it anyway in case examples use trellis.last.object()
        odev <- dev.cur()
        dev.set(dummydev)
        plot(x, ...)
        dev.set(odev)
    }
})
reset <- function()
    lattice.options(print.function = NULL)

## set up file connection for HTML
out <- file("content.html", "w")
## get function descriptions
info <- library(help = "latticeExtra")$info[[2]]

genGroup <- function(txt, expr)
{
    write(c('<div class="group">',
            '  <h2 class="groupname">', txt, '  </h2>'),
          file = out)
    force(expr)
    write('</div>', file = out)
}

gen <- function(name, which, width = 500, height = 350)
{
    ## generate PNG image of example number 'which' in ?name
    .plotNumber <<- 0
    .plotName <<- name
    target <<- which
    filename <- paste("images/", name, ".png", sep = "")
    CairoPNG(filename, width = width, height = height)
    try(eval.parent(call("example", name, local = TRUE, ask = FALSE)))
    dev.off()
    stopifnot(.plotNumber >= target)
    message(filename, " generated")
    ## generate HTML chunk
    desc <- info[grep(sprintf("^%s ", name), info)]
    desc <- sub(sprintf("^%s ", name), "", desc)
    aTag <- sprintf('  <a href="%s%s.html">', baseLink, name)
    write(c('<div class="item">',
            '  <div class="itemname">', aTag, name, '  </a></div>',
            '  <div class="itemdesc">', desc, '  </div>',
            aTag,
            sprintf('  <img src="%s" alt="%s" width="%g" height="%g"/>',
                    filename, name, width, height),
            '  </a>',
            '</div>'), file = out)
}

genGroup("general statistical plots", {
    gen("rootogram", 3, width = 600, height = 400)
    gen("segplot", 3, width = 400, height = 500)
    gen("ecdfplot", 1, height = 280)
    gen("marginal.plot", 2)
})

genGroup("functions of one variable", {
    gen("panel.smoother", 2)
    gen("panel.quantile", 4)
    ## time series functions
    gen("panel.xblocks", 3)
    gen("panel.xyarea", 1)
    gen("panel.tskernel", 1)
    ## xyplot.stl?
})

genGroup("functions of two variables", {
    gen("mapplot", 3)
    gen("tileplot", 3)
    gen("panel.levelplot.points", 1, width = 600)
    gen("panel.2dsmoother", 2)
    gen("dendrogramGrob", 1, height = 550)
})

genGroup("utilities", {
    gen("useOuterStrips", 1)
    gen("resizePanels", 3, width = 400, height = 500)
    gen("panel.ablineq", 7)
    gen("panel.3dbars", 2, height = 400)
    ## panel.qqmath.tails
})

genGroup("extended trellis framework", {
    gen("layer", 10)
    gen("as.layer", 2)
    gen("doubleYScale", 4)
    gen("c.trellis", 9, width = 600)
})

genGroup("styles", {
    gen("theEconomist.theme", 2)
    ## TODO: write examples for custom.theme?
})

## TODO: include the dataset examples too?

close(out)

## merge content.html into template.html
content <- readLines("content.html")
template <- readLines("template.html")
index <- sub("@CONTENT", paste(content, collapse = "\n"), template)
write(index, file = "index.html")
