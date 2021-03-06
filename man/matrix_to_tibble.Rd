% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers_ggcorrmat.R
\name{matrix_to_tibble}
\alias{matrix_to_tibble}
\title{Convert a matrix to a tibble dataframe.}
\usage{
matrix_to_tibble(df, var = "variable")
}
\arguments{
\item{df}{A matrix.}

\item{var}{Name of column to use for rownames.}
}
\description{
Convert a matrix to a tibble dataframe.
}
\examples{
set.seed(123)
cor_df <- cor(purrr::keep(iris, is.numeric))
ggstatsplot:::matrix_to_tibble(cor_df)
}
\author{
Indrajeet Patil
}
\keyword{internal}
