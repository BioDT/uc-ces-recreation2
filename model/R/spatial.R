# NOTE: abandon the following: use terra instead of sf

# Read shapefile
# shapefile <- sf::st_read(shapefile_path)

# Drop the Z (elevation) dimension if present
# shapefile <- sf::stzm(shapefile, drop = TRUE, what = "ZM")

# Transform to WGS84 (EPSG 4326)
# crs <- sf::st_crs(shapefile)$epsg
# if (is.na(crs) || crs != 4326) {
#    sf::st_transform(shapefile, crs = 4326)
# }
