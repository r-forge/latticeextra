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
             codeSrcSpec = NA,
             do.examples = TRUE)
{
    ## persistent global:
    tracker <- new.env()
    tracker$plot <- NULL
    tracker$name <- NA

    ## we want to be able to run example() for each function
    ## but only to keep *one* of the lattice plots produced

    ## the following approach will only work for examples which
    ## don't include post-plotting annotations, or grid.new etc.

    ## set the lattice print function to store the target plot.
    lattice.options(print.function = function(x, ...) {
        plot(x, ...)
        ## by default, use the first plot
        if (is.null(tracker$plot)) {
            tracker$plot <- x
        }
        ## special variable set in example() code:
        if (exists(".featured_example", globalenv()) &&
            (identical(.featured_example, TRUE) ||
             identical(.featured_example, tracker$name)))
        {
            tracker$plot <- x
            rm(list = ".featured_example", envir = globalenv())
        }
    })

    ## set up connections for HTML
    out <- textConnection("out_dump", "w") ## @CONTENT
    nav <- textConnection("nav_dump", "w") ## @NAV

    ## get names, aliases and descriptions from help pages
    info <- .readRDS(system.file("Meta", "Rd.rds", package = package))

    ## work out which help page (which element of 'info') each item belongs to
    itemNames <- unlist(lapply(spec, lapply, head, 1))
    in.info <- unlist(lapply(spec, lapply, function(x) {
        name <- x[[1]]
        helpname <- if (is.null(x$helpname)) name else x$helpname
        i <- which(info$Name == helpname)
        if (length(i) == 0) NA else i
    }))
    ok <- !is.na(in.info)
    info$itemName <- NA
    info$itemName[in.info[ok]] <- itemNames[ok]
    ## TODO: insert website items which do not match a help page name?
    #itemNames[!ok]
    ## remove help pages for which there is no item on website
    info <- info[!is.na(info$itemName),]

    ## construct local HTML links
    lens <- sapply(info$Aliases, length)
    Links <- structure(paste("#", rep.int(info$itemName, lens), sep = ""),
                       names = unlist(info$Aliases))
    Links2 <- character()

    ## fill in 'desc' element of spec from Title field for each item
    spec <- lapply(spec, lapply, function(x) {
        if (is.null(x$desc)) {
            name <- x[[1]]
            helpname <- if (is.null(x$helpname)) name else x$helpname
            i <- which(sapply(info$Aliases, function(aa) helpname %in% aa))
            x$desc <- info$Title[i]
            if (is.null(x$desc)) stop("no description found for ", name)
        }
        x
    })

    genItem <-
        function(name, do.example = do.examples,
                 helpname = name, examplename = helpname,
                 codefile = paste(helpname, ".R", sep = ""),
                 desc = NULL, helplink = TRUE,
                 width = 500, height = 350,
                 rerun = FALSE)
        {
            ## for filenames and DOM ids
            okname <- gsub(" ", "_", name)

            exampleBlock <- ""
            if (do.example) {
                ## generate PNG image of target plot in example(examplename)
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
                                    col_whitebg = col.whitebg(),
                                    classic_gray = standard.theme("X11"),
                                    custom_theme = custom.theme(),
                                    custom_theme_2 = custom.theme.2(),
                                    theEconomist = theEconomist.theme())
                    trellis.par.set(theme)
                    if (firstrun || rerun) {
                        tracker$plot <- NULL
                        tracker$name <- name
                        if (exists(".featured_example", globalenv()))
                            rm(list = ".featured_example", envir = globalenv())
                        ## run the example()s for this function
                        eval.parent(call("example", examplename, package = package,
                                         local = FALSE, ask = FALSE))
                        if (is.null(tracker$plot))
                            stop("no example() plots were found for ", name)
                        firstrun <- FALSE
                    }
                    dev.new(width = width/72, height = height/72)
                    trellis.par.set(theme)
                    plot(tracker$plot)
                    dev2bitmap(thisfile, width = width, height = height,
                               units = "px", taa = 4, gaa = 4, method = "pdf")
                    dev.off()
                    message(thisfile, " generated")
                }
                fileurl <- paste(imageSrcBase, filename, sep = "")
                theCall <- tracker$plot$call
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
                          '  </pre>', sep = "\n")
            }

            helplinkBlock <- ""
            if (helplink) {
                ## generate HTML man page file
                if (!file.exists("man"))
                    dir.create("man")
                manhtml <- paste("man/", helpname, ".html", sep = "")
                manRd <- paste(man.src.dir, helpname, ".Rd", sep = "")
                tools::Rd2HTML(manRd, out = manhtml, package = package,
                               Links = Links, Links2 = Links2)
                message(manhtml, " generated")
                ## generated HTML is invalid; fix it:
                tmp <- readLines(manhtml)
                #tmp <- gsub('</p>\n<p>', '<br/>', tmp)
                #tmp <- gsub('</?p>', '', tmp)
                tmp <- sub('^<!DOCTYPE .*$', '', tmp)
                tmp <- sub('^<meta .*$', '', tmp)
                tmp <- sub('^<link .*$', '', tmp)
                tmp <- gsub('<hr/?>', "", tmp)
                write(tmp, manhtml)
                ## generate HTML content
                helplinkBlock <-
                    paste('  <p>',
                          sprintf('  <a href="man/%s.html" class="helplink">',
                                helpname),
                          'Usage, Details, Examples', '</a>',
                          '  </p>', sep = "\n")
            }

            ## link to source code file
            codelinkBlock <- ""
            if (!is.na(codeSrcSpec) && !is.na(codefile)) {
                codeurl <- sprintf(codeSrcSpec, codefile)
                codelinkBlock <-
                    sprintf('<p><a href="%s" class="codelink">Source code</a></p>',
                            codeurl)
            }

            write(c(sprintf('<div class="item" id="%s">', okname),
                    '  <h2 class="itemname">', name, '  </h2>',
                    '  <div class="itemdesc">', desc, '  </div>',
                    helplinkBlock,
                    exampleBlock,
                    codelinkBlock,
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
            do.call("genItem", group[[j]])
        }
        write('</ul></li>', file = nav)
        write(c('', ''), file = out)
    }

    write(c('<script type="text/javascript">',
            paste('var imageSrcBase = "', imageSrcBase, '";', sep = ""),
            '</script>'), file = out)

    close(nav)
    close(out)

    ## make @INDEX
    tmp <- lapply(spec, lapply, function(x) {
        c(name = x[[1]], desc = x$desc)
    })
    idxmat <- do.call("rbind", unlist(tmp, recursive = FALSE))
    idxmat <- idxmat[order(idxmat[,1]),]
    index <-
        with(as.data.frame(idxmat),
             paste("<table>",
                   paste('<tr><th><a href="', paste("#", name, sep = ''), '">',
                         name, '</a></th>',
                         '<td>', desc, '</td></tr>',
                         sep = '', collapse = "\n"),
                   "</table>", sep = "\n"))

    ## make @VERSIONTAG
    Rvstring <- paste("R version",
                      paste(R.version[c("major", "minor")], collapse="."))
    nowstring <- paste("(at ", Sys.Date(), ")", sep = "")
    vTag <- paste(package, "version",
                  packageDescription(package)$Version,
                  "on", Rvstring, nowstring)

    ## merge content and nav into template.html
    html <- readLines("template.html")
    html <- sub("@CONTENT", paste(out_dump, collapse = "\n"), html)
    html <- sub("@NAV", paste(nav_dump, collapse = "\n"), html)
    html <- sub("@INDEX", index, html)
    html <- sub("@VERSIONTAG", vTag, html)

    write(html, file = "index.html")
    message("index.html generated")

    ## reset to normal plotting
    lattice.options(print.function = NULL, default.theme = NULL)
}
