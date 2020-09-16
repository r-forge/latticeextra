library(latticeExtra)

p <- xyplot(demand ~ Time, BOD, type = "h")
c(A = p, B = p, layout = c(1, 2), x.same = TRUE) # works
c(A = p, layout = c(1, 1), x.same = TRUE) # A should show

