## code to prepare `mapsheets_100k` dataset goes here

mapsheets_100k <- sf::st_read("data-raw/mapsheets_100k.shp")

mapsheets_100k <- dplyr::select(mapsheets_100k, mapnumber, maptitle, geometry)

mapsheets_100k$name <- stringr::str_to_title(mapsheets_100k$maptitle)

mapsheets_100k <- mapsheets_100k[, c("mapnumber", "name", "geometry")]

usethis::use_data(mapsheets_100k, overwrite = TRUE)

rm(mapsheets_100k)
