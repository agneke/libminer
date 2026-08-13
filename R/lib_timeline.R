#' Plot a timeline of when your packages were installed
#'
#' Builds a simple timeline showing when each installed package was last
#' (re)installed, using the modification time of each package's
#' `DESCRIPTION` file as a proxy for its install date. This makes it easy to
#' spot bursts of installation activity (e.g. setting up for a course or
#' project) versus quiet stretches.
#'
#' @param since Optional `Date` (or a string coercible to one, e.g.
#'   `"2025-01-01"`). If supplied, only packages installed on or after this
#'   date are included.
#' @param by_library Color points by library path? Defaults to `TRUE`.
#'
#' @returns Invisibly, a `data.frame` with columns `Package`, `LibPath`, and
#'   `InstallDate`, for the packages included in the plot.
#' @export
#'
#' @examples
#' lib_timeline()
#' lib_timeline(since = "2025-01-01")
lib_timeline <- function(since = NULL, by_library = TRUE) {
  pkgs <- utils::installed.packages()
  desc_paths <- file.path(pkgs[, "LibPath"], pkgs[, "Package"], "DESCRIPTION")
  mtimes <- file.mtime(desc_paths)

  keep <- !is.na(mtimes)
  if (!any(keep)) {
    stop("Could not determine install dates for any installed packages.")
  }

  timeline <- data.frame(
    Package = pkgs[keep, "Package"],
    LibPath = pkgs[keep, "LibPath"],
    InstallDate = as.Date(mtimes[keep]),
    stringsAsFactors = FALSE
  )

  if (!is.null(since)) {
    since <- as.Date(since)
    timeline <- timeline[timeline$InstallDate >= since, , drop = FALSE]
  }

  timeline <- timeline[order(timeline$InstallDate), , drop = FALSE]

  if (nrow(timeline) == 0) {
    message("No packages installed on or after ", since, "; nothing to plot.")
    return(invisible(timeline))
  }

  # Stack same-day installs vertically so simultaneous installs are visible
  # as a cluster rather than overplotted at y = 0. as.numeric() drops the
  # Date class that ave() would otherwise carry through to the y-axis.
  y <- as.numeric(stats::ave(
    as.numeric(timeline$InstallDate),
    timeline$InstallDate,
    FUN = function(x) seq_along(x)
  ))

  if (by_library) {
    lib_levels <- unique(timeline$LibPath)
    colors <- grDevices::hcl.colors(length(lib_levels), palette = "Dark 3")
    point_col <- colors[match(timeline$LibPath, lib_levels)]
  } else {
    point_col <- "steelblue"
  }

  graphics::plot(
    timeline$InstallDate, y,
    col = point_col, pch = 16,
    xlab = "Install date", ylab = "Packages installed that day",
    main = "Your R Library Timeline"
  )

  if (by_library && length(unique(timeline$LibPath)) > 1) {
    graphics::legend(
      "topleft",
      legend = lib_levels,
      col = colors,
      pch = 16,
      cex = 0.7,
      bty = "n"
    )
  }

  invisible(timeline)
}
