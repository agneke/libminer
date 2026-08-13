#' Plot your R libraries as a starburst
#'
#' Draws a colorful polar ("starburst") plot with one wedge per library
#' returned by [lib_summary()]. Wedge length reflects either the number of
#' installed packages or the on-disk size of each library, and wedges are
#' colored using a smooth [grDevices::hcl.colors()] palette.
#'
#' @param sizes Plot library sizes instead of package counts?
#' @param palette Name of an [grDevices::hcl.colors()] palette to color the
#'   wedges with.
#'
#' @returns Invisibly, the `data.frame` (from [lib_summary()]) used to build
#'   the plot.
#' @export
#'
#' @examples
#' lib_starburst()
lib_starburst <- function(sizes = FALSE, palette = "Spectral") {
  data <- lib_summary(sizes = sizes)
  value <- if (sizes) as.numeric(data$lib_size) else data$n_packages
  labels <- basename(data$Library)
  n <- length(value)

  # Scale radius by sqrt so wedge *area* is proportional to value
  r <- sqrt(value / max(value))

  gap <- 0.04
  edges <- seq(0, 2 * pi, length.out = n + 1)
  colors <- grDevices::hcl.colors(n, palette = palette)

  old_par <- graphics::par(bg = "grey10", mar = c(1, 1, 3, 1))
  on.exit(graphics::par(old_par))

  graphics::plot.new()
  graphics::plot.window(xlim = c(-1.4, 1.4), ylim = c(-1.4, 1.4), asp = 1)

  for (i in seq_len(n)) {
    theta <- seq(edges[i] + gap / 2, edges[i + 1] - gap / 2, length.out = 60)
    x <- c(0, r[i] * cos(theta), 0)
    y <- c(0, r[i] * sin(theta), 0)
    graphics::polygon(x, y, col = colors[i], border = "grey10", lwd = 1.5)

    mid_theta <- mean(edges[i:(i + 1)])
    graphics::text(
      1.15 * cos(mid_theta), 1.15 * sin(mid_theta),
      labels[i],
      col = "white", cex = 0.75
    )
  }

  graphics::title(main = "Your R Library Universe", col.main = "white", cex.main = 1.3)

  invisible(data)
}
