#' nearest accessible position
#'
#' nearest() calculates the nearest position to the given coordinates which can be accessed by car.
#' The coordinate-standard is WGS84. Attention: The OSRM API v4 is only working locally, but
#' not with the 'OSRM' webserver.
#'
#' @param lat, A numeric (-90 < lat < 90)
#' @param lng, A numeric (-180 < lng < 180)
#' @param api_version, A numeric (either 4 or 5)
#' @param localhost, A logical (TRUE = localhost is used, FALSE = onlinehost is used)
#' @param timeout A numeric indicating the timeout between server requests (in order to prevent queue overflows). Default is 0.001s.
#'
#' @return A data.frame with lat and lng
#' @export
#'
#' @examples
#' \dontrun{
#' osrmr::nearest(47,9, 5, FALSE)
#'
#' Sys.setenv("OSRM_PATH_API_5"="C:/OSRM_API5")
#' osrmr::run_server(Sys.getenv("OSRM_PATH_API_5"), "switzerland-latest.osrm")
#' osrmr::nearest(47,9, 5, TRUE)
#' osrmr::quit_server()
#' Sys.unsetenv("OSRM_PATH_API_5")
#'
#' Sys.setenv("OSRM_PATH_API_4"="C:/OSRM_API4")
#' osrmr::run_server(Sys.getenv("OSRM_PATH_API_4"), "switzerland-latest.osrm")
#' osrmr::nearest(47,9, 4, TRUE)
#' osrmr::quit_server()
#' Sys.unsetenv("OSRM_PATH_API_4")}
nearest <- function(lat, lng, api_version = 5, localhost = F, timeout = 0.001) {
  assertthat::assert_that(api_version %in% c(4,5))

  address <- server_address(localhost)
  Sys.sleep(timeout)
  if (api_version == 4) {
    nearest <- nearest_api_v4(lat, lng, address)
  } else {
    nearest <- nearest_api_v5(lat, lng, address)
  }
  return(nearest)
}


#' nearest accessible position for OSRM API v4
#'
#' nearest_api_v4() calculates the nearest position to the given coordinates which can be accessed
#' by car with the OSRM API 4. The coordinate-standard is WGS84. Attention: The OSRM API v4
#' is only working locally, but not with the 'OSRM' webserver.
#'
#' @param lat, A numeric (-90 < lat < 90)
#' @param lng, A numeric (-180 < lng < 180)
#' @param address, A character specifying the serveraddress (local or online)
#'
#' @return A data.frame with lat and lng
#'
#' @examples
#' \dontrun{
#' Sys.setenv("OSRM_PATH_API_4"="C:/OSRM_API4")
#' osrmr::run_server(Sys.getenv("OSRM_PATH_API_4"), "switzerland-latest.osrm")
#' osrmr:::nearest_api_v4(47,9, osrmr:::server_address(TRUE))
#' osrmr::quit_server()
#' Sys.unsetenv("OSRM_PATH_API_4")}
nearest_api_v4 <- function(lat, lng, address) {
  request <- paste(address, "/nearest?loc=", lat, ",", lng, sep = "", NULL)
  nearest <- make_request(request)$mapped_coordinate
  nearest <- data.frame(
    lat = nearest[1],
    lng = nearest[2]
  )
  return(nearest)
}

#' nearest accessible position for OSRM API v5
#'
#' nearest_api_v5() calculates the nearest position to the given coordinates which can be accessed
#' by car with the OSRM API v5. The coordinate-standard is WGS84.
#'
#' @param lat, A numeric (-90 < lat < 90)
#' @param lng, A numeric (-180 < lng < 180)
#' @param address, A character specifying the serveraddress (local or online)
#'
#' @return A data.frame with lat and lng

#' @examples
#' \dontrun{
#' osrmr:::nearest_api_v5(47,9, osrmr:::server_address(FALSE))
#' Sys.setenv("OSRM_PATH_API_5"="C:/OSRM_API5")
#' osrmr::run_server(Sys.getenv("OSRM_PATH_API_5"), "switzerland-latest.osrm")
#' osrmr:::nearest_api_v5(47,9, osrmr:::server_address(TRUE))
#' osrmr::quit_server()
#' Sys.unsetenv("OSRM_PATH_API_5")}
nearest_api_v5 <- function(lat, lng, address) {
  request <-paste(address, "/nearest/v1/driving/", lng, ",", lat, "?number=1", sep = "", NULL)
  nearest <- make_request(request)$waypoints[[1]]$location
  nearest <- data.frame(
    lat = nearest[2],
    lng = nearest[1]
  )
  return(nearest)
}


