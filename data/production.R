devtools::load_all("../model")

terra::terraOptions(
    memfrac = 0.7,
    datatype = "INTU1", # write everything as unsigned 8 bit int
    print = TRUE
)

.feature_mappings <- get_feature_mappings(load_config())


get_files <- function(data_dir) {
    # Generate a mapping { layer : file_path }
    file_paths <- lapply(
        list.files(path = data_dir, pattern = "\\.tif$", recursive = TRUE),
        function(file_) file.path(data_dir, file_)
    )
    file_stems <- lapply(
        file_paths,
        function(path) tools::file_path_sans_ext(basename(path))
    )
    files <- setNames(file_paths, file_stems)

    return(files)
}

quantise_slope <- function(layer) {
    # Quantise the slope values
    # NOTE: I do not know the origin of these intervals
    slope_rcl <- data.matrix(data.frame(
        lower_bound = c(0, 1.72, 2.86, 5.71, 11.31, 16.7),
        upper_bound = c(1.72, 2.86, 5.71, 11.31, 16.7, Inf),
        mapped_to = c(1, 2, 3, 4, 5, 6)
    ))
    return(terra::classify(layer, rcl = slope_rcl))
}

reproject_layer <- function(infile, outfile) {
    if (basename(infile) == "FIPS_N_Slope.tif") {
        layer <- terra::rast(infile) |> quantise_slope()
    } else {
        layer <- terra::rast(infile)
    }

    onto <- terra::rast(
        crs = "EPSG:27700",
        res = c(20, 20),
        ext = terra::ext(-10000, 660000, 460000, 1220000) # xmin, xmax, ymin, ymax
    )

    terra::project(
        layer,
        onto,
        method = "near",
        filename = outfile,
        datatype = "INT1U",
        threads = TRUE,
        overwrite = TRUE
    )
}

.one_hot_layer_old <- function(infile, outfile, feature_mapping) {
    layer <- terra::rast(infile)
    stopifnot(terra::nlyr(layer) == 1)

    sublayer_stack <- lapply(
        # NOTE: These names are integer values (Raster_Val column in config.csv)
        feature_mapping,
        function(i) {
            sublayer_i <- terra::ifel(layer == as.numeric(i), 1, NA)
            names(sublayer_i) <- names(feature_mapping)[i]
            return(sublayer_i)
        }
    )
    terra::writeRaster(
        terra::rast(sublayer_stack),
        outfile,
        datatype = "INT1U",
        overwrite = TRUE
    )
}

one_hot_layer <- function(infile, outfile, feature_mapping) {
    layer <- terra::rast(infile)
    stopifnot(terra::nlyr(layer) == 1)

    one_hot_pixel <- function(x) {
        out <- matrix(0, nrow = length(x), ncol = length(feature_mapping))
        for (i in seq_along(feature_mapping)) {
            out[, i] <- ifelse(x == as.numeric(feature_mapping[i]), 1, NA)
        }
        return(out)
    }

    layer <- terra::lapp(
        layer,
        fun = one_hot_pixel,
        filename = outfile,
        overwrite = TRUE,
        wopt = list(
            names = names(feature_mapping),
            datatype = "INT1U"
        )
    )
}

compute_distance_layer <- function(infile, outfile) {
    layer <- terra::rast(infile)
    path <- "Scotland/boundaries.shp"
    aoi <- terra::vect(path)
    aoi <- terra::ext(aoi)
    xmin <- terra::xmin(aoi)
    xmax <- terra::xmax(aoi)
    ymin <- terra::ymin(aoi)
    ymax <- terra::ymax(aoi)
    aoi <- terra::ext(
        xmin,
        xmax,
        # ymin,
        ymin + (ymax - ymin) / 10,
        ymax
    )
    layer <- terra::crop(layer, aoi)
    terra::distance(
        layer,
        target = 0,
        unit = "m",
        method = "haversine",
        maxdist = 1500, # NOTE: this requires terra version 1.8.21 !!
        filename = outfile
    )
}

map_distance_to_unit_layer <- function(infile, outfile) {
    logistic_func <- function(x, kappa = 6, alpha = 0.01011) {
        (kappa + 1) / (kappa + exp(alpha * x))
    }

    layer <- terra::rast(infile)
    terra::app(
        layer,
        fun = logistic_func,
        filename = outfile
    )
}


time <- function(func, ...) {
    start_time <- Sys.time()
    result <- func(...)
    end_time <- Sys.time()
    delta <- difftime(end_time, start_time, units = "secs")
    cat("Took", delta, "seconds\n")
    return(result)
}


reproject_all <- function(indir, outdir) {
    infiles <- get_files(indir)

    # NOTE: Stage 0 data contains more layers than are used in the final potential
    # Drop any tiffs whose name does not match a layer name in .feature_mappings
    infiles <- infiles[intersect(names(infiles), names(.feature_mappings))]
    stopifnot(all(names(.feature_mappings) %in% names(infiles)))

    for (infile in infiles) {
        outfile <- sub("^[^/]+", outdir, infile)
        dir.create(dirname(outfile), recursive = TRUE, showWarnings = FALSE)

        message(paste("Reprojecting:", infile, "->", outfile))

        time(reproject_layer, infile, outfile)
    }
}

one_hot_all <- function(indir, outdir) {
    infiles <- get_files(indir)
    stopifnot(all(names(.feature_mappings) %in% names(infiles)))

    for (infile in infiles) {
        outfile <- sub("^[^/]+", outdir, infile)
        dir.create(dirname(outfile), recursive = TRUE, showWarnings = FALSE)

        layer_name <- tools::file_path_sans_ext(basename(infile))
        feature_mapping <- .feature_mappings[[layer_name]]

        message(paste("Converting to one-hot representation:", infile, "->", outfile))

        time(one_hot_layer, infile, outfile, feature_mapping)
    }
}


stack_all <- function(indir, outdir) {
    for (component in c("SLSRA", "FIPS_N", "FIPS_I", "Water")) {
        infiles <- get_files(file.path(indir, component))

        outfile <- file.path(outdir, paste0(component, ".tif"))
        dir.create(dirname(outfile), recursive = TRUE, showWarnings = FALSE)

        message(paste("Stacking", component, "into a single raster:", indir, "->", outfile))

        stacked <- terra::rast(lapply(infiles, terra::rast))

        terra::writeRaster(stacked, outfile, datatype = "INT1U", overwrite = TRUE)
    }
}

compute_distance_all <- function(indir, outdir) {
    for (component in c("FIPS_I", "Water")) {
        infiles <- get_files(file.path(indir, component))

        for (infile in infiles) {
            outfile <- sub("^[^/]+", outdir, infile)
            dir.create(dirname(outfile), recursive = TRUE, showWarnings = FALSE)

            message(paste("Performing distance calculation:", infile, "->", outfile))

            time(compute_distance_layer, infile, outfile)
        }
    }
    for (component in c("SLSRA", "FIPS_N")) {
        message(paste("Creating symbolic link:", indir, "->", outdir))
        file.symlink(file.path(indir, component), file.path(outdir, component))
    }
}

map_distance_to_unit_all <- function(indir, outdir) {
    for (component in c("FIPS_I", "Water")) {
        infiles <- get_files(file.path(indir, component))

        for (infile in infiles) {
            outfile <- sub("^[^/]+", outdir, infile)
            dir.create(dirname(outfile), recursive = TRUE, showWarnings = FALSE)

            message(paste("Mapping distances to unit interval:", infile, "->", outfile))

            time(map_distance_to_unit_layer, infile, outfile)
        }
    }
    for (component in c("SLSRA", "FIPS_N")) {
        message(paste("Creating symbolic link:", indir, "->", outdir))
        file.symlink(file.path(indir, component), file.path(outdir, component))
    }
}


if (!interactive()) {
    # reproject_all(indir = "Stage_0", outdir = "Stage_1")
    one_hot_all(indir = "data/Stage_1", outdir = "data/Stage_2")
    # stack_all(indir = "Stage_2", outdir = "Stage_3")
    # compute_distance_all(indir = "Stage_2", outdir = "Stage_3")
    # map_distance_to_unit_all(indir = "Stage_3", outdir = "Stage_4")
} else {
    print("dogs!")
}
