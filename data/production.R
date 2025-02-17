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

one_hot_layer_old <- function(infile, outfile, feature_mapping) {
    layer <- terra::rast(infile)
    stopifnot(terra::nlyr(layer) == 1)

    sublayer_stack <- lapply(
        # NOTE: These names are integer values (Raster_Val column in config.csv)
        names(feature_mapping),
        function(i) {
            sublayer_i <- terra::ifel(layer == as.numeric(i), 1, 0)
            # NOTE: feature_mapping[i] may be "feature_j" where j =\= i !
            # E.g. FIPS_N_Landform_2 has a 'Raster_Val' of 3, unfortunately
            names(sublayer_i) <- feature_mapping[i]
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

    raster_vals <- names(feature_mapping)

    one_hot_pixel <- function(x) {
        out <- matrix(0, nrow = length(x), ncol = length(raster_vals))
        for (i in seq_along(raster_vals)) {
            out[, i] <- ifelse(x == as.numeric(raster_vals[i]), 1, 0)
        }
        return(out)
    }

    layer <- terra::lapp(
        layer,
        fun = one_hot_pixel,
        filename = outfile,
        # datatype = "INT1U",
        overwrite = TRUE
    )

    names(layer) <- feature_mapping
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

        message(paste("Stacking", component, "into a single raster", outfile))

        stacked <- terra::rast(lapply(infiles, terra::rast))

        terra::writeRaster(stacked, outfile, datatype = "INT1U", overwrite = TRUE)
    }
}

if (!interactive()) {
    reproject_all(indir = "Stage_0", outdir = "Stage_1")
    one_hot_all(indir = "Stage_1", outdir = "Stage_2")
    stack_all(indir = "Stage_2", outdir = "Stage_3")
}
