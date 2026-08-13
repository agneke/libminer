test_that("lib_timeline returns expected structure", {
  grDevices::pdf(nullfile())
  res <- lib_timeline()
  grDevices::dev.off()

  expect_s3_class(res, "data.frame")
  expect_equal(names(res), c("Package", "LibPath", "InstallDate"))
  expect_type(res$Package, "character")
  expect_type(res$LibPath, "character")
  expect_s3_class(res$InstallDate, "Date")
  expect_gt(nrow(res), 0)
  # Results should be sorted oldest to newest.
  expect_true(!is.unsorted(res$InstallDate))
})

test_that("since filters out packages installed before that date", {
  grDevices::pdf(nullfile())
  res_all <- lib_timeline()
  res_recent <- lib_timeline(since = max(res_all$InstallDate))
  grDevices::dev.off()

  expect_true(all(res_recent$InstallDate >= max(res_all$InstallDate)))
  expect_lte(nrow(res_recent), nrow(res_all))
})

test_that("since accepts a string date", {
  grDevices::pdf(nullfile())
  res <- lib_timeline(since = "2000-01-01")
  grDevices::dev.off()

  expect_s3_class(res$InstallDate, "Date")
})

test_that("an implausibly future since date yields zero rows and a message", {
  grDevices::pdf(nullfile())
  expect_message(
    res <- lib_timeline(since = Sys.Date() + 3650),
    "nothing to plot"
  )
  grDevices::dev.off()

  expect_equal(nrow(res), 0)
  expect_equal(names(res), c("Package", "LibPath", "InstallDate"))
})

test_that("by_library = FALSE still returns valid data", {
  grDevices::pdf(nullfile())
  res <- lib_timeline(by_library = FALSE)
  grDevices::dev.off()

  expect_s3_class(res, "data.frame")
  expect_gt(nrow(res), 0)
})
