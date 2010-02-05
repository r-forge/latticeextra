## Copyright (C) Felix Andrews <felix@nfrac.org>


## reads template.html from current directory.
## [over]writes index.html.
## runs examples and puts images into 'plots' dir.
##   (currently uses dev2bitmap to make pngs)
## runs Rdconv and puts HTML into 'man' dir.
## 'spec': see arguments to nested "genItem" function...
## 'man.src.dir': path to man/.Rd files
generateWebsite <-
    function(package, spec, man.src.dir,
             themeNames = c("default", "black_and_white", "classic_gray",
                            "custom_theme", "custom_theme_2", "theEconomist"),
             imageSrcBase = "",
             do.examples = TRUE)
{
    ## global variables:
    .plotNumber <<- 0
    .thePlot <<- NULL
    .target <<- NA

    ## we want to be able to run example() for each function
    ## but only to keep *one* of the lattice plots produced
    ## (specified by number).
    
    ## the following approach will only work for examples which
    ## don't include post-plotting annotations, or grid.new etc.

    ## set the lattice print function to keep a counter
    ## and stop after the target plot number.
    lattice.options(print.function = function(x, ...) {
        .plotNumber <<- .plotNumber + 1
        message("  plot number ", .plotNumber)
        plot(x, ...)
        if (.plotNumber == .target) {
            .thePlot <<- x
        }
    })

    ## set up connections for HTML
    out <- textConnection("out_dump", "w") ## @CONTENT
    nav <- textConnection("nav_dump", "w") ## @NAV

    ## get function descriptions
    info <- library(help = package, character.only = TRUE)$info[[2]]
    infoContinues <- grepl("^ ", info)

    ## this only works for direct links: (names not aliases)
    itemNames <- unlist(lapply(spec, names), use.names = FALSE)
    Links <- structure(paste("#", itemNames, sep = ""),
                       names = itemNames)

    genItem <-
        function(name, examplenumber = NA, helpname = name, 
                 desc = NULL, helplink = TRUE,
                 width = 500, height = 350,
                 rerun = FALSE)
        {
            ## for filenames and DOM ids
            okname <- gsub(" ", "_", name)

            if (do.examples == FALSE) examplenumber <- NA
    
            exampleBlock <- ""
            if (!is.na(examplenumber)) {
                ## generate PNG image of example number 'examplenumber' in ?helpname
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
                        .target <<- examplenumber
                        .plotNumber <<- 0
                        eval.parent(call("example", helpname, package = package,
                                         local = FALSE, ask = FALSE))
                        stopifnot(.plotNumber >= .target)
                        thePlot <- .thePlot
                        firstrun <- FALSE
                    }
                    dev.new(width = width/72, height = height/72)
                    trellis.par.set(theme)
                    plot(thePlot)
                    dev2bitmap(thisfile, width = width, height = height,
                               units = "px", taa = 4, gaa = 4, method = "pdf")
                    dev.off()
                    message(thisfile, " generated")
                }
                filename <- paste("plots/default/", okname, ".png", sep = "")
                fileurl <- paste(imageSrcBase, filename, sep = "")
                theCall <- thePlot$call
                if (identical(theCall[[1]], quote(update)) &&
                    (length(theCall) == 2)) {
                    ## redundant `update` wrapper; remove for clarity
                    theCall <- theCall[[2]]
                }
                itemCode <- toString(paste(deparse(theCall, control = c()),
                                           collapse = "\n"),
                                     width = 160)
                exampleBlock <-
                    paste('  <p>One example:</p>',
                          sprintf('  <img src="%s" alt="%s" width="%g" height="%g"/>',
                                  fileurl, name, width, height),
                          '  <pre class="itemcode">', itemCode,
                          '  </pre>')
            }

            if (is.null(desc)) {
                ## get description of this function
                i <- grep(sprintf("^%s ", helpname), info)
                if (length(i) == 0) {
                    desc <- ""
                } else {
                    desc <- sub(sprintf("^%s +", helpname), "", info[i])
                    if (isTRUE(infoContinues[i+1]))
                        desc <- paste(desc, info[i+1])
                    desc <- gsub(" +", " ", desc)
                }
            }
    
            helplinkBlock <- ""
            if (helplink) {
                ## generate HTML man page file
                manhtml <- paste("man/", helpname, ".html", sep = "")
                manRd <- paste(man.src.dir, helpname, ".Rd", sep = "")
                tools::Rd2HTML(manRd, out = manhtml, package = package,
                               Links = Links, Links2 = Links)
                message(manhtml, " generated")
                ## generated HTML is invalid (R 2.11.0-devel); fix it:
                tmp <- readLines(manhtml)
                tmp <- gsub('</p>\n<p>', '<br/>', tmp)
                tmp <- gsub('</?p>', '', tmp)
                tmp <- sub('^<!DOCTYPE .*$', '', tmp)
                tmp <- sub('^<meta .*$', '', tmp)
                tmp <- sub('^<link .*$', '', tmp)
                tmp <- gsub('<hr/?>', "", tmp)
                write(tmp, manhtml)
                ## generate HTML content
                aTag <- sprintf('  <a href="man/%s.html" class="helplink">',
                                helpname)
                helplinkBlock <-
                    paste('  <p>', aTag,
                          'Usage, Details, Examples', '</a>',
                          '  </p>')
            }
    
            write(c(sprintf('<div class="item" id="%s">', okname),
                    '  <h2 class="itemname">', name, '  </h2>',
                    '  <div class="itemdesc">', desc, '  </div>',
                    helplinkBlock,
                    exampleBlock,
                    '</div>', ''), file = out)
            ## generate HTML nav
            navid <- paste("nav_", okname, sep = "")
            write(c('<li>',
                    sprintf('<a class="navitem" href="%s" title="%s" id="%s">%s</a>',
                            paste("#", okname, sep=""), desc, navid, name),
                    '</li>'), file = nav)
        }

    ## process the given spec
    for (i in seq_along(spec)) {
        groupName <- names(spec)[i]
        group <- spec[[i]]
        write(sprintf('  <h1 class="groupname">%s</h1>', groupName),
              file = out)
        write(c(sprintf('<li class="navhead"><a href="#">%s</a></li>',
                        groupName),
                '<li class="navgroup"><ul>'), file = nav)
        ## each item:
        for (j in seq_along(group)) {
            item <- group[[j]]
            item$name <- names(group)[j]
            do.call("genItem", item)
        }
        write('</ul></li>', file = nav)
        write(c('', ''), file = out)
    }

    write(c('<script type="text/javascript">',
            paste('var imageSrcBase = "', imageSrcBase, '";', sep = ""),
            '</script>'), file = out)

    close(nav)
    close(out)

    ## make @VERSIONTAG
    Rvstring <- paste("R version",
                      paste(R.version[c("major", "minor")], collapse="."))
    nowstring <- paste("(at ", Sys.Date(), ")", sep = "")
    vTag <- paste(package, "version",
                  packageDescription(package)$Version,
                  "on", Rvstring, nowstring)

    ## merge content and nav into template.html
    index <- readLines("template.html")
    index <- sub("@CONTENT", paste(out_dump, collapse = "\n"), index)
    index <- sub("@NAV", paste(nav_dump, collapse = "\n"), index)
    index <- sub("@VERSIONTAG", vTag, index)

    write(index, file = "index.html")
    message("index.html generated")
    
    ## reset to normal plotting
    lattice.options(print.function = NULL, default.theme = NULL)
}
