% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/web_query_functions.R
\name{query_elvis}
\alias{query_elvis}
\title{Query the ELVIS online archive for data within a bounding box}
\usage{
query_elvis(
  x,
  years = NULL,
  datatype = c("Point Clouds", "DEMs", "Reflectance", "DSMs", "Bathymetry")
)
}
\arguments{
\item{x}{An object from which to derive a bounding box for the query. Can be
any of the following: 
\itemize{
  \item{An \code{sf} bounding box object (e.g. created using the 
    \code{st_bbox} function).}
  \item{An \code{sf} object from which a non-empty bounding box can be 
    derived, e.g. a spatial data frame, or a single polygon or line 
    feature, but not a point geometry.} 
  \item{A named, four-element numeric vector where the names are 
    \code{'xmin', 'ymin', 'xmax', 'ymax'}. }
  \item{An unnamed four-element numeric vector, assumed to be ordered as
    \code{xmin, ymin, xmax, ymax}. }
 }}

\item{years}{A vector of one or more 4-digit year numbers to filter the query
results, or \code{NULL} (default) for all available years.}

\item{datatype}{The type of data to query. Options are: 
\code{"Point Clouds", "DEMs", "Reflectance", "DSMs", "Bathymetry"}.
Presently only the \code{"Point Clouds"} option is supported.}
}
\value{
A data frame
}
\description{
This function queries the ELVIS online archive for data within the area
defined by a bounding box derived from the input argument \code{x}.
Typically, \code{x} will be a spatial object, such as an \code{sf} geometry
or data frame, or a numeric vector of min and max x and y values. If the
object has an associated coordinate reference system, the bounding
coordinates will be transformed to GDA 2020 longitudes and latitudes
(EPSG:7844). If no coordinate reference system is defined, the coordinates
are assumed to be GDA2020 longitudes and latitudes.
}
