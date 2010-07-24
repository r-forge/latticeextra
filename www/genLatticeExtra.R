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
         list("segplot", 3, width = 400, height = 500),
         list("ecdfplot"),
         list("marginal.plot", 2)
     )

spec[["functions of one variable"]] <-
    list(
         list("xyplot.stl", codefile = "timeseries.R", height = 500, rerun = TRUE),
         list("panel.smoother", 2),
         list("panel.quantile", -1),
         list("panel.xblocks", 3, width = 600, height = 200, rerun = TRUE),
         list("panel.xyarea", 2, rerun = TRUE),
         list("panel.tskernel", rerun = TRUE),
         list("horizonplot", 3, height = 550)
     )

spec[["functions of two variables"]] <-
    list(
         list("mapplot", -1, width = 600),
         list("tileplot", 3),
         list("panel.levelplot.points", width = 600,
           helpname = "panel.voronoi", codefile = "tileplot.R"),
         list("panel.2dsmoother", 2),
         list("dendrogramGrob", height = 550)
     )

spec[["utilities"]] <-
    list(
         list("useOuterStrips", codefile = "utilities.R"),
         list("resizePanels", width = 400, height = 550,
           codefile = "utilities.R"),
         list("scale.components"),
         list("panel.ablineq", helpname = "panel.lmlineq", -1),
         list("panel.scaleArrow", height = 400, rerun = TRUE),
         list("panel.3dmisc", 2, height = 400),
         list("panel.key")
     )

spec[["extended trellis framework"]] <-
    list(
         list("layer", -1),
         list("as.layer", 4, codefile = "doubleYScale.R"),
         list("doubleYScale", 4),
         list("c.trellis", -3, width = 600)
     )

spec[["styles"]] <-
    list(
         list("style example", examplename = "custom.theme",
           desc = "This is a sample plot to demonstrate different graphical settings (themes).",
           do.helplink = FALSE, codefile = NA),
         list("custom.theme", -2),
         list("ggplot2like", 5, helpname = "ggplot2like.theme"),
         list("theEconomist.theme", 3, codefile = "theeconomist.R")
     )

spec[["data"]] <-
    list(
         list("USAge", codefile = NA),
         list("USCancerRates", examplename = "mapplot", 1, width = 600, codefile = NA),
         list("ancestry", do.example = FALSE, codefile = NA),
         list("postdoc", codefile = NA),
         list("biocAccess", height = 550, codefile = NA, rerun = TRUE),
         list("gvhd10", height = 500, codefile = NA),
         list("SeatacWeather", examplename = "doubleYScale", -2, codefile = NA),
         list("EastAuClimate", 4, codefile = NA)
     )

source("generate.R")

## stop on errors
lattice.options(panel.error = NULL)

themes <-
    list(default = list(theme = standard.theme("pdf")),
         black_and_white = list(theme = standard.theme(color = FALSE)),
         custom_theme = list(theme = custom.theme()),
         custom_theme_2 = list(theme = custom.theme.2()),
         col_whitebg = list(theme = col.whitebg()),
         ggplot2like = list(theme = ggplot2like(n = 4, h.start = 180), options = ggplot2like.opts()),
         theEconomist = list(theme = theEconomist.theme(), options = theEconomist.opts())
         )

imageSrcBase <- "http://150.203.60.53/latticeExtra/"

generateWebsite("latticeExtra", spec = spec,
                man.src.dir = "../pkg/man/",
                image.src.base = imageSrcBase,
                topleveljs = paste('var imageSrcBase = "', imageSrcBase, '";', sep = ""),
                code.url = "http://r-forge.r-project.org/scm/viewvc.php/pkg/R/%s?view=markup&root=latticeextra",
                themes = themes)
