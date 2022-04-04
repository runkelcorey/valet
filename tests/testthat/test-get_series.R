test_that("get_series returns full dataset", {
  expect_equal(nrow(get_series("SWP-R1N1983Q2")), 78)
})

test_that("get_series includes date variable", {
  expect_s3_class(get_series("CES_C4E_LOSE_JOB_SK")$date, "Date")
})
