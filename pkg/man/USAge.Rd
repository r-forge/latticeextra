\name{USAge}
\alias{USAge}
\alias{USAge.table}
\alias{USAge.df}
\docType{data}
\title{ US national population estimates }
\description{
  US national population estimates by age and sex from 1900 to 1979.
  The data is available both as a (3-dimensional) table and a data
  frame.  The second form omits the 75+ age group to keep age numeric.
}

\usage{
data(USAge.table)
data(USAge.df)
}

\format{
  \code{USAge.table} is a 3-dimensional array with dimensions 
  \tabular{rll}{
    No \tab Name \tab Levels\cr
    1 \tab Age \tab 0, 1, 2, \dots, 74, 75+\cr
    2 \tab Sex \tab Male, Female\cr
    3 \tab Year \tab 1900, 1901, \dots, 1979 \cr
  }
  Cells contain raw counts of estimated population.

  \code{USAge.df} is a data frame with 12000 observations on the
  following 4 variables.
  \describe{
    \item{\code{Age}}{a numeric vector, giving age in years}
    \item{\code{Sex}}{a factor with levels \code{Male} \code{Female}}
    \item{\code{Year}}{a numeric vector, giving year}
    \item{\code{Population}}{a numeric vector, giving population in
      millions}
  }
}

\details{

  The data for 1900-1929 are rounded to thousands.  The data for
  1900-1939 exclude the Armed Forces overseas and the population
  residing in Alaska and Hawaii.  The data for 1940-1949 represent the
  resident population plus Armed Forces overseas, but exclude the
  population residing in Alaska and Hawaii.  The data for 1950-1979
  represent the resident population plus Armed Forces overseas, and
  also include the population residing in Alaska and Hawaii.

}

\source{

  U.S. Census Bureau website: \url{https://www.census.gov/}

  %% Original URL
  %% \url{http://www.census.gov/popest/data/national/asrh/pre-1980/PE-11.html} is no longer valid
  
  The data were available as individual files for each year, with
  varying levels for the margins.  The preprocessing steps used to
  reduce the data to the form given here are described in the scripts
  directory.
  
}

\examples{
data(USAge.df)
head(USAge.df)

## Figure 10.7 from Sarkar (2008)
xyplot(Population ~ Age | factor(Year), USAge.df,
       groups = Sex, type = c("l", "g"),
       auto.key = list(points = FALSE, lines = TRUE, columns = 2),
       aspect = "xy", ylab = "Population (millions)",
       subset = Year \%in\% seq(1905, 1975, by = 10))
}
\keyword{datasets}



