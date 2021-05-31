# osrmr 0.1.36

* Avoid calls to 'closeAllConnections()', as necessary change to remain on CRAN.

# osrmr 0.1.35

* Introduce an optional parameter 'timeout' for the functions 'viaroute' and 'nearest' that is preset to 0.001s. This prevents errors from server queue overflows.
* Improved error handling in 'viaroute' in order to comply with the CRAN policy on 'failing gracefully'.

# osrmr 0.1.29

* Set examples using OSRMR webserver to "dontrun" because of check errors due to flaky web server
* Bugfix in viaroute when using instructions
* Updated documentation

# osrmr 0.1.28

* Added a `NEWS.md` file to track changes to the package.
* Basic functionality as described in readme.md and vignette.



