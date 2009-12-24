# setwd("X:/Packages/latticeextra/www")

library(latticeExtra)
library(grid)
library(Cairo)

## stop on errors
lattice.options(panel.error = NULL)

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

## start a default device to catch the plots we don't want
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
        e <- simpleError("target plot completed; stopping (OK)")
        class(e) <- c("normalStop", "condition")
        stop(e)
    } else {
        ## plot it anyway on another device
        ## can't ignore it in case examples use trellis.last.object()
        odev <- dev.cur()
        dev.set(dummydev)
        plot(x, ...)
        dev.set(odev)
    }
})

## set up file connections for HTML
out <- file("content.html", "w")
nav <- file("nav.html", "w")
## get function descriptions
info <- library(help = "latticeExtra")$info[[2]]

genGroup <- function(txt, expr)
{
    write(sprintf('  <h2 class="groupname">%s</h2>', txt),
          file = out)
    write(c('<li><a class="subnav">', txt, '</a></li>',
            '<li><ul>'), file = nav)
    force(expr)
    write('</ul></li>', file = nav)
    write(c('', ''), file = out)
}

gen <- function(name, which, width = 500, height = 350)
{
    ## generate PNG image of example number 'which' in ?name
    .plotNumber <<- 0
    .plotName <<- name
    target <<- which
    filename <- paste("plotimg/", name, ".png", sep = "")
    CairoPNG(filename, width = width, height = height)
    tryCatch(eval.parent(call("example", name, local = FALSE, ask = FALSE)),
             normalStop = function(e) message(e))
    dev.off()
    stopifnot(.plotNumber >= target)
    message(filename, " generated")
    ## get description of this function
    desc <- info[grep(sprintf("^%s ", name), info)]
    if (length(desc) == 0) desc <- ""
    desc <- sub(sprintf("^%s +", name), "", desc)
    ## generate HTML content
    nav.id <- gsub("\\.", "_", name)
    item.id <- paste(nav.id, "_item", sep = "")
    aTag <- sprintf('  <a href="%s%s.html">', baseLink, name)
    write(c(sprintf('<div class="item" id="%s">', item.id),
            '  <h3 class="itemname">', name, '  </h3>',
            '  <div class="itemdesc">', desc, '  </div>',
            '  <p>', aTag, 'Usage, Details, Examples', '</a>', '</p>',
            '  <p>One example:</p>',
            sprintf('  <img src="%s" alt="%s" width="%g" height="%g"/>',
                    filename, name, width, height),
            '</div>', ''), file = out)
    ## generate HTML nav
    write(c('<li>',
            sprintf('<a class="nav" href="%s" title="%s" id="%s">%s</a>',
                    filename, desc, nav.id, name),
            '</li>'), file = nav)}

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
    ## TODO: write examples for custom.theme
    gen("theEconomist.theme", 2)
})

## TODO: include the dataset examples too?

close(nav)
close(out)

## merge content.html into template.html
content <- readLines("content.html")
navtxt <- readLines("nav.html")
index <- readLines("template.html")
index <- sub("@CONTENT", paste(content, collapse = "\n"), index)
index <- sub("@NAV", paste(navtxt, collapse = "\n"), index)
write(index, file = "index.html")

## reset to normal plotting
lattice.options(print.function = NULL)
