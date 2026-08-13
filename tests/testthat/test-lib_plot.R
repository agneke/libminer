test_that("lib_starburst runs without error and returns lib_summary data", {
  grDevices::pdf(nullfile())
  res <- lib_starburst()
  grDevices::dev.off()

  expect_s3_class(res, "data.frame")
  expect_equal(names(res), c("Library", "n_packages"))
})

test_that("sizes argument is passed through to lib_summary", {
  grDevices::pdf(nullfile())
  res <- lib_starburst(sizes = TRUE)
  grDevices::dev.off()

  expect_equal(names(res), c("Library", "n_packages", "lib_size"))
})
