## generate the web site

## setwd("X:/Packages/latticeextra/www")
## Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs8.63/bin/gswin32c.exe")
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
           helpname = "panel.voronoi"),
         list("panel.2dsmoother"),
         list("dendrogramGrob", height = 550)
     )

spec[["utilities"]] <-
    list(
         list("useOuterStrips"),
         list("resizePanels", width = 400, height = 550,
           helpname = "useOuterStrips",
           desc = "Resize panels to match data scales"),
         list("panel.ablineq", helpname = "panel.lmlineq"),
         list("panel.scaleArrow", height = 400, rerun = TRUE),
         list("panel.3dmisc", height = 400)
         ## panel.qqmath.tails
     )

spec[["extended trellis framework"]] <-
    list(
         list("layer"),
         list("as.layer"),
         list("doubleYScale"),
         list("c.trellis", width = 600)
     )

spec[["styles"]] <-
    list(
         list("style example", examplename = "custom.theme", 
           desc = "This is a sample plot to demonstrate different graphical settings (themes).",
           helplink = FALSE),
         list("custom.theme"),
         list("theEconomist.theme")
         )

spec[["data"]] <-
    list(
         list("USAge"),
         list("USCancerRates", examplename = "mapplot", width = 600),
         list("ancestry", do.example = FALSE),
         list("postdoc"),
         list("biocAccess", height = 550),
         list("gvhd10", height = 500),
         list("SeatacWeather", examplename = "doubleYScale"),
         list("EastAuClimate")
     )

source("generate.R")

## stop on errors
lattice.options(panel.error = NULL)

generateWebsite("latticeExtra", spec = spec, 
                man.src.dir = "../pkg/man/",
                imageSrcBase = "http://150.203.60.53/latticeExtra/",
                do.examples = TRUE)
