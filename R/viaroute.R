#' travel time or full information of a route
#'
#' For a given start- and end-destination, viaroute() calculates route informations using OSRM.
#' OSRM chooses the nearest point which can be accessed by car for the start- and end-destination.
#' The coordinate-standard is WGS84.
#' Attention: The OSRM API-4 is only working locally, but not with the onlinehost.
#'
#' @param lat1 A numeric (-90 < lat1 < 90) -> start-destination
#' @param lng1 A numeric (-180 < lng1 < 180) -> start-destination
#' @param lat2 A numeric (-90 < lat2 < 90) -> end-destination
#' @param lng2 A numeric (-180 < lng2 < 180) -> end-destination
#' @param instructions A logical. If FALSE, only the traveltime (in seconds, as numeric) will be returned.
#'  If TRUE, more details of the route are returned (as list).
#' @param api_version A numeric (either 4 or 5)
#' @param localhost A logical (TRUE = localhost is used, FALSE = onlinehost is used)
#' @param timeout A numeric indicating the timeout between server requests (in order to prevent queue overflows). Default is 0.001s.
#'
#' @return a numeric or a list (depending on instructions)
#' @export
#'
#' @examples
#' # direct examples of the online API
#' \dontrun{
#' #' link <- "http://router.project-osrm.org/route/v1/driving/8.1,47.1;8.3,46.9?steps=false"
#' a <- rjson::fromJSON(file = link)
#'
#' # example with onlinehost API5
#' osrmr:::viaroute(47.1, 8.1, 46.9, 8.3, FALSE, 5, FALSE)
#'
#' # examples with localhost API4/API5
#' Sys.setenv("OSRM_PATH"="C:/OSRM_API4")
#' osrmr::run_server("switzerland-latest.osrm")
#' osrmr::viaroute(47.1, 8.1, 46.9, 8.3, FALSE, 4, TRUE)
#' osrmr::quit_server()
#' Sys.unsetenv("OSRM_PATH")
#'
#' Sys.setenv("OSRM_PATH"="C:/OSRM_API5")
#' osrmr::run_server("switzerland-latest.osrm")
#' osrmr::viaroute(47.1, 8.1, 46.9, 8.3, FALSE, 5, TRUE)
#' osrmr::quit_server()
#' Sys.unsetenv("OSRM_PATH")}
viaroute <- function(lat1, lng1, lat2, lng2, instructions, api_version, localhost, timeout = 0.001) {
  assertthat::assert_that(api_version %in% c(4,5))
  address <- server_address(localhost)

  Sys.sleep(timeout)
  if (api_version == 4) {
    viaroute_api_v4(lat1, lng1, lat2, lng2, instructions, address)
  } else {
    viaroute_api_v5(lat1, lng1, lat2, lng2, instructions, address)
  }

}


#' travel time or full information of a route for OSRM API 4
#'
#' For a given start- and end-destination, viaroute() calculates route informations using OSRM API 4.
#' OSRM chooses the nearest point which can be accessed by car for the start and destination.
#' The coordinate-standard is WGS84.
#' Attention: The OSRM API-4 is only working locally, but not with the onlinehost.
#'
#' @param lat1 A numeric (-90 < lat1 < 90) -> start-destination
#' @param lng1 A numeric (-180 < lng1 < 180) -> start-destination
#' @param lat2 A numeric (-90 < lat2 < 90) -> end-destination
#' @param lng2 A numeric (-180 < lng2 < 180) -> end-destination
#' @param instructions A logical. If FALSE, only the traveltime (in seconds, as numeric) will be returned.
#'  If TRUE, more details of the route are returned (as list).
#' @param address A character specifying the serveraddress (local or online)
#'
#' @return a numeric or a list (depending on parameter instructions)
#'
#' @examples
#' \dontrun{
#' Sys.setenv("OSRM_PATH"="C:/OSRM_API4")
#' osrmr::run_server("switzerland-latest.osrm")
#' osrmr:::viaroute_api_v4(47,9,48,10, FALSE, osrmr:::server_address(TRUE))
#' osrmr::quit_server()
#' Sys.unsetenv("OSRM_PATH")}
viaroute_api_v4 <- function(lat1, lng1, lat2, lng2, instructions, address) {
  request <- paste(address, "/viaroute?loc=",
                   lat1, ',', lng1, '&loc=', lat2, ',', lng2, sep = "", collapse = NULL)
  res <- make_request(request)

  if (!instructions) {
    if (!res$status == 207) {
      return(res$route_summary$total_time)
    } else {
      t_guess <- 16*60
      warning("Route not found: ", paste(lat1, lng1, lat2, lng2, collapse = ", "),
              ". Travel time set to ", t_guess/60 , " min.")
      return(t_guess) # Guess a short walk of 2 minutes.
    }
  } else {
    return(res)
  }
}



#' travel time or full information of a route for OSRM API 5
#'
#' For a given start- and end-destination, viaroute() calculates route informations using OSRM API 5.
#' OSRM chooses the nearest point which can be accessed by car for the start and destination.
#' The coordinate-standard is WGS84.
#' Attention: The OSRM API-4 is only working locally, but not with the onlinehost.
#'
#' @param lat1 A numeric (-90 < lat1 < 90) -> start-destination
#' @param lng1 A numeric (-180 < lng1 < 180) -> start-destination
#' @param lat2 A numeric (-90 < lat2 < 90) -> end-destination
#' @param lng2 A numeric (-180 < lng2 < 180) -> end-destination
#' @param instructions A logical. If FALSE, only the traveltime (in seconds, as numeric) will be returned.
#'  If TRUE, more details of the route are returned (as list).
#' @param address A character specifying the serveraddress (local or online)
#'
#' @return a numeric or a list (depending on parameter instructions)
#'
#' @examples
#' \dontrun{
#' # example with onlinehost
#' osrmr:::viaroute_api_v5(47, 9, 48, 10 , FALSE, osrmr:::server_address(FALSE))
#'
#' # example with localhost
#' Sys.setenv("OSRM_PATH"="C:/OSRM_API5")
#' osrmr::run_server("switzerland-latest.osrm")
#' osrmr:::viaroute_api_v5(47, 9, 48, 10 , FALSE, osrmr:::server_address(TRUE))
#' osrmr::quit_server()
#' Sys.unsetenv("OSRM_PATH")}
viaroute_api_v5 <- function(lat1, lng1, lat2, lng2, instructions, address) {
  if (!instructions) {
    request <- paste(address, "/route/v1/driving/",
                     lng1, ",", lat1, ";", lng2, ",", lat2,
                     "?overview=false", sep = "", NULL)
  } else {
    request <- paste(address, "/route/v1/driving/",
                     lng1, ",", lat1, ";", lng2, ",", lat2,
                     "?overview=full", sep = "", NULL)
  }
  res <- make_request(request)

  assertthat::assert_that(assertthat::is.number(res$routes[[1]]$duration))

  if (!instructions) {
    if (res$code == "Ok") {
      return(res$routes[[1]]$duration)
    }
    else {
      t_guess <- 16*60
      warning("Route not found: ", paste(lat1, lng1, lat2, lng2, collapse = ", "),
              ". Travel time set to ", t_guess/60 , " min.")
    }
  } else {
    return(res)
  }
}

