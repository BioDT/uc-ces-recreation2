% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/config.R
\name{load_persona}
\alias{load_persona}
\title{Load Persona}
\usage{
load_persona(csv_path, name = NULL)
}
\arguments{
\item{csv_path}{\code{character} Path to a csv file containing one or more personas}

\item{name}{\code{character} Name of the persona, which should match a column name}
}
\value{
\code{integer} A named vector of integers representing the persona
}
\description{
Loads a single persona from a csv file containing one or more personas.
If the file contains more than one persona (i.e. columns), a name specifying
which personal (column) to load must also be provided.
}
