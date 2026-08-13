# Plot a timeline of when your packages were installed

Builds a simple timeline showing when each installed package was last
(re)installed, using the modification time of each package's
`DESCRIPTION` file as a proxy for its install date. This makes it easy
to spot bursts of installation activity (e.g. setting up for a course or
project) versus quiet stretches.

## Usage

``` r
lib_timeline(since = NULL, by_library = TRUE)
```

## Arguments

- since:

  Optional `Date` (or a string coercible to one, e.g. `"2025-01-01"`).
  If supplied, only packages installed on or after this date are
  included.

- by_library:

  Color points by library path? Defaults to `TRUE`.

## Value

Invisibly, a `data.frame` with columns `Package`, `LibPath`, and
`InstallDate`, for the packages included in the plot.

## Examples

``` r
lib_timeline()

lib_timeline(since = "2025-01-01")
```
