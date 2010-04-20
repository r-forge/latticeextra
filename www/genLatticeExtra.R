## generate the web site

## setwd("X:/Packages/latticeextra/www")
## Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs8.63/bin/gswin32c.exe")
## Sys.setenv(R_GSCMD = "D:/Program Files/GPLGS/gswin32c.exe")
## source("genLatticeExtra.R", echo = TRUE)

library(latticeExtra)

spec <- list()

spec[["general statistical plots"]] <-
    list(
         list("rootogram"),
         list("segplot", width = 400, height = 500),
         list("ecdfplot"),
         list("marginal.plot")
         )

spec[["functions of one variable"]] <-
    list(
         list("xyplot.stl", codefile = "timeseries.R", height = 500, rerun = TRUE),
         list("panel.smoother"),
         list("panel.quantile"),
         list("panel.xblocks", width = 600, height = 200, rerun = TRUE),
         list("panel.xyarea", rerun = TRUE),
         list("panel.tskernel", rerun = TRUE),
         list("horizonplot", height = 550)
     )

spec[["functions of two variables"]] <-
    list(
         list("mapplot", width = 600),
         list("tileplot"),
         list("panel.levelplot.points", width = 600,
           helpname = "panel.voronoi", codefile = "tileplot.R"),
         list("panel.2dsmoother"),
         list("dendrogramGrob", height = 550)
     )

spec[["utilities"]] <-
    list(
         list("useOuterStrips", codefile = "utilities.R"),
         list("resizePanels", width = 400, height = 550,
           codefile = "utilities.R"),
         list("panel.ablineq", helpname = "panel.lmlineq"),
         list("panel.scaleArrow", height = 400, rerun = TRUE),
         list("panel.3dmisc", height = 400)
     )

spec[["extended trellis framework"]] <-
    list(
         list("layer"),
         list("as.layer", codefile = "doubleYScale.R"),
         list("doubleYScale"),
         list("c.trellis", width = 600)
     )

spec[["styles"]] <-
    list(
         list("style example", examplename = "custom.theme",
           desc = "This is a sample plot to demonstrate different graphical settings (themes).",
           helplink = FALSE, codefile = NA),
         list("custom.theme"),
         list("theEconomist.theme", codefile = "theeconomist.R")
         )

spec[["data"]] <-
    list(
         list("USAge", codefile = NA),
         list("USCancerRates", examplename = "mapplot", width = 600, codefile = NA),
         list("ancestry", do.example = FALSE, codefile = NA),
         list("postdoc", codefile = NA),
         list("biocAccess", height = 550, codefile = NA, rerun = TRUE),
         list("gvhd10", height = 500, codefile = NA),
         list("SeatacWeather", examplename = "doubleYScale", codefile = NA),
         list("EastAuClimate", codefile = NA)
     )

source("generate.R")

## stop on errors
lattice.options(panel.error = NULL)

generateWebsite("latticeExtra", spec = spec,
                man.src.dir = "../pkg/man/",
                imageSrcBase = "http://150.203.60.53/latticeExtra/",
                codeSrcSpec = "http://r-forge.r-project.org/plugins/scmsvn/viewcvs.php/pkg/R/%s?root=latticeextra&view=markup",
                do.examples = TRUE)
