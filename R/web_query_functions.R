#' Create an ELVIS url for a given bounding box
#' 
#' This function is primarily intended as a helper that is called by the
#' \code{\link{query_elvis}} function, but you might want to use it directly,
#' e.g. to create a URL that you then paste into a browser.
#' 
#' @param x An object from which to derive a bounding box for the query. Can be
#'   any of the following: 
#'   \itemize{
#'     \item{An \code{sf} bounding box object (e.g. created using the 
#'       \code{st_bbox} function).}
#'     \item{An \code{sf} object from which a non-empty bounding box can be 
#'       derived, e.g. a spatial data frame, or a single polygon or line 
#'       feature, but not a point geometry.} 
#'     \item{A named, four-element numeric vector where the names are 
#'       \code{'xmin', 'ymin', 'xmax', 'ymax'}. }
#'     \item{An unnamed four-element numeric vector, assumed to be ordered as
#'       \code{xmin, ymin, xmax, ymax}. }
#'    }
#'   
#' @param base_url The base URL for the ELVIS archive. Currently this is:
#'   \code{"https://elvis2018-ga.fmecloud.com/fmedatastreaming/elvis_indexes/ReturnDownloadables.fmw"}.
#'   
#' @return A URL to query ELVIS.
#' 
#' @export
#' 
create_elvis_query_url <- function(x,
  base_url = "https://elvis2018-ga.fmecloud.com/fmedatastreaming/elvis_indexes/ReturnDownloadables.fmw") {
  
  request_list <- httr::parse_url(base_url)
  
  bb <- .get_bbox(x)
  
  poly <- sf::st_as_sfc(bb)
  wkt <- sf::st_as_text(poly)
  
  request_list$query <- list(polygon = wkt)
  httr::build_url(request_list)
}


# Helper to get an sf bbox object for some input vector, geometry,
# raster etc.
#
.get_bbox <- function(x) {
  if (is.numeric(x) && is.vector(x)) {
    if (!length(x) == 4) {
      stop("Numeric vector should have four elements")
      
    } else if (is.null(names(x))) {
      message("Assuming order: xmin, ymin, xmax, ymax")
      names(x) <- c("xmin", "ymin", "xmax", "ymax")
      
    } else {
      names(x) <- tolower(names(x))
      if (!all(names(x) %in% c("xmin", "ymin", "xmax", "ymax"))) {
        stop("Expected vector names: xmin, ymin, xmax, ymax")
      }
    }
  }
  
  bb <- tryCatch(sf::st_bbox(x), error = function(e) NULL)
  
  if (is.null(bb)) {
    stop("Unable to determine bounding box")
  } 
  
  bb
}


#' Query the ELVIS online archive for data within a bounding box
#' 
#' This function queries the ELVIS online archive for data within the area
#' defined by a bounding box derived from the input argument \code{x}.
#' Typically, \code{x} will be a spatial object, such as an \code{sf} geometry
#' or data frame, or a numeric vector of min and max x and y values. If the
#' object has an associated coordinate reference system, the bounding
#' coordinates will be transformed to GDA 2020 longitudes and latitudes
#' (EPSG:7844). If no coordinate reference system is defined, the coordinates
#' are assumed to be GDA2020 longitudes and latitudes. 
#' 
#' 
#' @param x An object from which to derive a bounding box for the query. Can be
#'   any of the following: 
#'   \itemize{
#'     \item{An \code{sf} bounding box object (e.g. created using the 
#'       \code{st_bbox} function).}
#'     \item{An \code{sf} object from which a non-empty bounding box can be 
#'       derived, e.g. a spatial data frame, or a single polygon or line 
#'       feature, but not a point geometry.} 
#'     \item{A named, four-element numeric vector where the names are 
#'       \code{'xmin', 'ymin', 'xmax', 'ymax'}. }
#'     \item{An unnamed four-element numeric vector, assumed to be ordered as
#'       \code{xmin, ymin, xmax, ymax}. }
#'    }
#'    
#' @param years A vector of one or more 4-digit year numbers to filter the query
#'   results, or \code{NULL} (default) for all available years.
#'   
#' @param datatype The type of data to query. Options are: 
#'   \code{"Point Clouds", "DEMs", "Reflectance", "DSMs", "Bathymetry"}.
#'   Presently only the \code{"Point Clouds"} option is supported.
#'   
#' @return A data frame
#' 
#' @export
#' 
query_elvis <- function(x, 
                        years = NULL,
                        datatype = c("Point Clouds", "DEMs", 
                                     "Reflectance", "DSMs", 
                                     "Bathymetry")) {
  
  datatype <- match.arg(datatype)
  
  if (datatype != "Point Clouds") {
    stop("Bummer: only 'Point Clouds' datatype is supported so far")
  }
  
  url <- create_elvis_query_url(x)
  response <- httr::GET(url)
  
  # parse response
  x <- httr::content(response, as = "text")
  x <- jsonlite::fromJSON(x)
  
  # extract table of available tiles
  dat <- x$available_data$downloadables$`Point Clouds`$AHD[[2]]
  
  # add an integer index column which is useful to match to the 
  # ELVIS web-page listings
  dat <- cbind(index = seq_len(nrow(dat)), dat)
  
  if (!is.null(years)) {
    file_years <- as.integer(
      stringr::str_replace(dat$file_name, "^[A-Za-z]+(\\d{4}).*$", "\\1") )
    
    ii <- file_years %in% years
    
    if (!any(ii)) {
      warning("No data for the specified years", immediate. = TRUE)
    } 
    dat <- dat[ii, , drop=FALSE]
  }
  
  dat
}

