# Plot your R libraries as a starburst

Draws a colorful polar ("starburst") plot with one wedge per library
returned by
[`lib_summary()`](https://agneke.github.io/libminer/reference/lib_summary.md).
Wedge length reflects either the number of installed packages or the
on-disk size of each library, and wedges are colored using a smooth
[`grDevices::hcl.colors()`](https://rdrr.io/r/grDevices/palettes.html)
palette.

## Usage

``` r
lib_starburst(sizes = FALSE, palette = "Spectral")
```

## Arguments

- sizes:

  Plot library sizes instead of package counts?

- palette:

  Name of an
  [`grDevices::hcl.colors()`](https://rdrr.io/r/grDevices/palettes.html)
  palette to color the wedges with.

## Value

Invisibly, the `data.frame` (from
[`lib_summary()`](https://agneke.github.io/libminer/reference/lib_summary.md))
used to build the plot.

## Examples

``` r
lib_starburst()
```
