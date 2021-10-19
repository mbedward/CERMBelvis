#' New South Wales 100k map sheets
#'
#' Key to 1:100,000 topographic map sheets for New South Wales.
#'
#' @format A spatial data frame (\code{sf} object) with 414 rows and 3 columns:
#'   \describe{
#'     \item{mapnumber}{4-digit map number}
#'     \item{name}{Map name in title case}
#'     \item{geometry}{Bounding polygon in GDA94 lat-lon coordinates}
#'   }
#'
#' @examples
#' \dontrun{
#' # Submit a query to ELVIS for the Wollongong map area
#' i <- grepl("wollongong", mapsheets_100k$name, ignore.case = TRUE)
#' res <- query_elvis(mapsheets_100k[i, ])
#' }
#'
"mapsheets_100k"
