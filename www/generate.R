# setwd("X:/Packages/latticeextra/www")
# Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs8.63/bin/gswin32c.exe")
# source("generate.R", echo = TRUE)

library(latticeExtra)
library(grid)

## stop on errors
lattice.options(panel.error = NULL)

helpLinkBase <- "http://bm2.genes.nig.ac.jp/RGM2/R_current/library/latticeExtra/man/"
#helpLinkBase <- "http://finzi.psych.upenn.edu/R/library/latticeExtra/html/"
imageSrcBase <- "http://150.203.60.53/latticeExtra/"

## we want to be able to run example() for each function
## but only to keep *one* of the plots produced
## (specified by number).

## the following approach will only work if the examples
## don't include post-plotting annotations, or grid.new etc.

## global variables:
.plotNumber <- 0
.thePlot <- NULL
target <- NA

## set the lattice print function to keep a counter
## and stop after the target plot number.
lattice.options(print.function = function(x, ...) {
    .plotNumber <<- .plotNumber + 1
    message("  plot number ", .plotNumber)
    plot(x, ...)
    if (.plotNumber == target) {
        .thePlot <<- x
        ## stop the example() call - avoid any base plots following
#        e <- simpleError("target plot completed; stopping (OK)")
#        class(e) <- c("normalStop", "condition")
#        stop(e)
    }
})

## set up file connections for HTML
out <- file("content.html", "w")
nav <- file("nav.html", "w")
## get function descriptions
info <- library(help = "latticeExtra")$info[[2]]
infoContinues <- grepl("^ ", info)

genGroup <- function(txt, expr)
{
    write(sprintf('  <h2 class="groupname">%s</h2>', txt),
          file = out)
    write(c('<li class="navhead"><a href="#">', txt, '</a></li>',
            '<li class="navgroup"><ul>'), file = nav)
    force(expr)
    write('</ul></li>', file = nav)
    write(c('', ''), file = out)
}

gen <- function(name, which, width = 500, height = 350,
                desc = NULL, examplename = name, extlink = TRUE,
                rerun = FALSE)
{
    ## generate PNG image of example number 'which' in ?name
    
    ## for filenames and DOM ids
    okname <- gsub(" ", "_", name)

    themeNames <- c("default", "black_and_white", "classic_gray",
                    "custom_theme", "custom_theme_2", "theEconomist")

    firstrun <- TRUE
    for (themeNm in themeNames) {
        if (!file.exists(file.path("plots", themeNm)))
            dir.create(paste("plots/", themeNm, sep = ""), recursive = TRUE)
        thisfile <- file.path("plots", themeNm, paste(okname, ".png", sep = ""))
        if (firstrun)
            filename <- thisfile
        theme <- switch(themeNm,
                        default = standard.theme("pdf"),
                        black_and_white = standard.theme(color = FALSE),
                        classic_gray = standard.theme("X11"),
                        custom_theme = custom.theme(),
                        custom_theme_2 = custom.theme.2(),
                        theEconomist = theEconomist.theme())
        trellis.par.set(theme)
        if (firstrun || rerun) {
            ## run the example() and stop after target plot
            target <<- which
            .plotNumber <<- 0
            tryCatch(eval.parent(call("example", examplename, local = FALSE, ask = FALSE)),
                     normalStop = function(e) message(e))
            stopifnot(.plotNumber >= target)
            thePlot <- .thePlot
            firstrun <- FALSE
        }
        dev.new(width = width/96, height = height/96)
        trellis.par.set(theme)
        plot(thePlot)
        dev2bitmap(thisfile, width = width, height = height,
                   units = "px", taa = 4, gaa = 4, method = "pdf")
        dev.off()
        message(thisfile, " generated")
    }
    filename <- paste("plots/default/", okname, ".png", sep = "")
    fileurl <- paste(imageSrcBase, filename, sep = "")

    ## get description of this function
    if (is.null(desc)) {
        i <- grep(sprintf("^%s ", examplename), info)
        if (length(i) == 0) {
            desc <- ""
        } else {
            desc <- sub(sprintf("^%s +", examplename), "", info[i])
            if (isTRUE(infoContinues[i+1]))
                desc <- paste(desc, info[i+1])
            desc <- gsub(" +", " ", desc)
        }
    }
    ## generate HTML content
    extlinkBlock <- ""
    if (extlink) {
        aTag <- sprintf('  <a href="%s%s.html">', helpLinkBase, examplename)
        extlinkBlock <-
            paste('  <p>', aTag,
                  'Usage, Details, Examples', '</a>',
                  '  </p>',
                  '  <p>One example:</p>')
    }
    theCall <- thePlot$call
    if (identical(theCall[[1]], quote(update)) &&
        (length(theCall) == 2)) {
        # redundant `update` wrapper; remove for clarity
        theCall <- theCall[[2]]
    }
    itemCode <- toString(paste(deparse(theCall, control = c()),
                               collapse = "\n"),
                         width = 160)
    write(c(sprintf('<div class="item" id="%s">', okname),
            '  <h3 class="itemname">', name, '  </h3>',
            '  <div class="itemdesc">', desc, '  </div>',
            extlinkBlock,
            sprintf('  <img src="%s" alt="%s" width="%g" height="%g"/>',
                    fileurl, name, width, height),
            '  <pre class="itemcode">', itemCode,
            '  </pre>',
            '</div>', ''), file = out)
    ## generate HTML nav
    navid <- paste("nav_", okname, sep = "")
    write(c('<li>',
            sprintf('<a class="navitem" href="%s" title="%s" id="%s">%s</a>',
                    paste("#", okname, sep=""), desc, navid, name),
            '</li>'), file = nav)}

genGroup("general statistical plots", {
    gen("rootogram", 1)
    gen("segplot", 3, width = 400, height = 500)
    gen("ecdfplot", 1)
    gen("marginal.plot", 2)
})

genGroup("functions of one variable", {
    gen("panel.smoother", 2)
    gen("panel.quantile", 4)
    gen("panel.xblocks", 3, width = 600, height = 200, rerun = TRUE)
    gen("panel.xyarea", 1, rerun = TRUE)
    gen("panel.tskernel", 1, rerun = TRUE)
    gen("horizonplot", 6, height = 550)
    ## xyplot.stl?
})

genGroup("functions of two variables", {
    gen("mapplot", 3, width = 600)
    gen("tileplot", 3)
    gen("panel.levelplot.points", 1, width = 600,
        examplename = "panel.voronoi")
    gen("panel.2dsmoother", 2)
    gen("dendrogramGrob", 1, height = 550)
})

genGroup("utilities", {
    gen("useOuterStrips", 1)
    gen("resizePanels", 3, width = 400, height = 550,
        examplename = "useOuterStrips",
        desc = "Resize panels to match data scales")
    gen("panel.ablineq", 6, examplename = "panel.lmlineq")
    gen("panel.scaleArrow", 1, height = 400, rerun = TRUE)
    gen("panel.3dmisc", 2, height = 400)
    ## panel.qqmath.tails
})

genGroup("extended trellis framework", {
    gen("layer", 10)
    gen("as.layer", 2)
    gen("doubleYScale", 4)
    gen("c.trellis", 9, width = 600)
})

genGroup("styles", {
    gen("style example", examplename = "custom.theme", which = 1,
        desc = "This is a sample plot to demonstrate different graphical settings (themes).",
        extlink = FALSE)
    gen("custom.theme", 3)
    gen("theEconomist.theme", 2)
})

## TODO: include the dataset examples too?

write(c('<script type="text/javascript">',
        paste('var imageSrcBase = "', imageSrcBase, '";', sep = ""),
        '</script>'), file = out)

close(nav)
close(out)

vTag <- paste("latticeExtra version",
              packageDescription("latticeExtra")$Version,
              "on", R.version.string)

## merge content.html into template.html
content <- readLines("content.html")
navtxt <- readLines("nav.html")
index <- readLines("template.html")
index <- sub("@CONTENT", paste(content, collapse = "\n"), index)
index <- sub("@NAV", paste(navtxt, collapse = "\n"), index)
index <- sub("@VERSIONTAG", vTag, index)

write(index, file = "index.html")

## reset to normal plotting
lattice.options(print.function = NULL, default.theme = theme)
