# cermbELVIS

An R package with functions to query the data directory of the ELVIS archive of LiDAR point cloud 
data maintained by Geoscience Australia (https://elevation.fsdf.org.au/). Written for use by the
Centre for Environmental Risk Management of Bushfires, University of Wollongong.

Presently, the functions in the package are just a quick hack to make it easier to query the
available LiDAR data sets for specified areas.

```
library(cermbELVIS)
library(dplyr, warn.conflicts = FALSE)
library(stringr)

# Query recent LiDAR data sets for the area of the Wollongong 100k map sheet
available_data <- mapsheets_100k %>%
  filter(name == "Wollongong") %>%
  query_elvis(years = 2019:2020)
  
```
