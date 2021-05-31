
<!-- README.md is generated from README.Rmd. Please edit that file -->
'osrmr'
-------

'osrmr' is a wrapper around the OSRM API (<https://github.com/Project-OSRM/osrm-backend/blob/master/docs/http.md>). 'osrmr' works with API versions 4 and 5 and can handle servers that run locally as well as the osrm webserver.

Installation
------------

You can install 'osrmr' from `CRAN` or `github` with:

``` r
install.packages("osrmr")

# install.packages("devtools")
devtools::install_github("ims-fhs/osrmr")
```

Examples
--------

Access the OSRM with R using the onlinehost (webserver) of OSRM to:

-   generate coordinates from given coordinates, which are accessible by car with `nearest()`
-   calculate waytimes and more for specific routes from start- to end-destination with `viaroute()`
-   decode polylines using a polyline-specific precision with `decode_geom()`

``` r
library(osrmr)
nearest(lat = 47, lng = 8, api_version = 5, localhost = FALSE)
#>        lat      lng
#> 1 47.00008 8.003016
viaroute(lat1 = 47.1, lng1 = 8.1, lat2 = 46.9, lng2 = 8.3, instructions = FALSE,
         api_version = 5, localhost = FALSE)
#> [1] 2637.1

encoded_polyline_precision_5 <- rjson::fromJSON(file = "http://router.project-osrm.org/route/v1/driving/8.0997,47.1002;8.101110,47.10430?steps=false&geometries=polyline")$routes[[1]]$geometry
decode_geom(encoded_polyline_precision_5, precision = 5)
#>        lat     lng
#> 1 47.10020 8.09970
#> 2 47.10099 8.09952
#> 3 47.10161 8.10037
#> 4 47.10171 8.10066
#> 5 47.10215 8.10083
#> 6 47.10234 8.10098
#> 7 47.10287 8.10123
#> 8 47.10322 8.10125
#> 9 47.10430 8.10110
```

### Note

1.  In order to use the localhost of OSRM you need a local build on your device. For more Information on the localhost see <https://github.com/Project-OSRM/osrm-backend/wiki/Building-OSRM>.
2.  When using the localhost it's recommended to set the path of your local build as environment variable.

For more detailed Information about the components of the 'osrmr' package, check out the vignette.
