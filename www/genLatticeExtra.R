## generate the web site

## setwd("X:/Packages/latticeextra/www")
## Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs8.63/bin/gswin32c.exe")
## source("genLatticeExtra.R", echo = TRUE)

library(latticeExtra)

spec <- list()

spec[["general statistical plots"]] <-
    list(
         "rootogram" = list(example = 1),
         "segplot" = list(example = 3, width = 400, height = 500),
         "ecdfplot" = list(example = 1),
         "marginal.plot" = list(example = 2)
         )

spec[["functions of one variable"]] <-
    list(
         "panel.smoother" = list(example = 2),
         "panel.quantile" = list(example = 4),
         "panel.xblocks" = list(example = 3, width = 600, height = 200, rerun = TRUE),
         "panel.xyarea" = list(example = 1, rerun = TRUE),
         "panel.tskernel" = list(example = 1, rerun = TRUE),
         "horizonplot" = list(example = 6, height = 550)
     )

spec[["functions of two variables"]] <-
    list(
         "mapplot" = list(example = 3, width = 600),
         "tileplot" = list(example = 3),
         "panel.levelplot.points" = list(example = 1, width = 600,
           helpname = "panel.voronoi"),
         "panel.2dsmoother" = list(example = 2),
         "dendrogramGrob" = list(example = 1, height = 550)
     )

spec[["utilities"]] <-
    list(
         "useOuterStrips" = list(example = 1),
         "resizePanels" = list(example = 3, width = 400, height = 550,
           helpname = "useOuterStrips",
           desc = "Resize panels to match data scales"),
         "panel.ablineq" = list(example = 6, helpname = "panel.lmlineq"),
         "panel.scaleArrow" = list(example = 1, height = 400, rerun = TRUE),
         "panel.3dmisc" = list(example = 2, height = 400)
         ## panel.qqmath.tails
     )

spec[["extended trellis framework"]] <-
    list(
         "layer" = list(example = 10),
         "as.layer" = list(example = 2),
         "doubleYScale" = list(example = 4),
         "c.trellis" = list(example = 9, width = 600)
     )

spec[["styles"]] <-
    list(
         "style example" = list(example = 1, helpname = "custom.theme", 
           desc = "This is a sample plot to demonstrate different graphical settings (themes).",
           helplink = FALSE),
         "custom.theme" = list(example = 3),
         "theEconomist.theme" = list(example = 2)
         )

spec[["data"]] <-
    list(
         "USAge" = list(),
         "USCancerRates" = list(),
         "ancestry" = list(),
         "postdoc" = list(example = 1),
         "biocAccess" = list(example = 1, height = 550),
         "gvhd10" = list(),
         "SeatacWeather" = list(),
         "EastAuClimate" = list(example = 3)
     )

source("generate.R")

## stop on errors
lattice.options(panel.error = NULL)

generateWebsite("latticeExtra", spec = spec, 
                man.src.dir = "../pkg/man/",
                imageSrcBase = "http://150.203.60.53/latticeExtra/",
                do.examples = TRUE)
