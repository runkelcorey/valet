test_that("get_group returns full dataset", {
  expect_equal(nrow(get_group("LEGACY_NOON_RATES")), 2504)
  expect_equal(ncol(get_group("LEGACY_NOON_RATES")), 66)
})
