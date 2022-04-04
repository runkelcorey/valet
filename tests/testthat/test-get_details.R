test_that("get_details returns full series", {
  expect_equal(get_details("LEGACY_NOON_RATES", group = T)$name, "LEGACY_NOON_RATES")
  expect_length(get_details("LEGACY_NOON_RATES", group = T)$groupSeries, 65)
})
