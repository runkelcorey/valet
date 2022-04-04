test_that("valet returns 200 status code for available datasets", {
  expect_equal(valet(sample(get_list("series")$name, 1))$response$status_code, 200)
})

test_that("valet returns valet", {
          expect_s3_class(valet("BAPF_TRANSACTION_DATA", group = T), "valet")
})

test_that("valet returns a nice message when group is unavailable", {
  expect_error(get_group("BAPF"), regexp = "^Valet request failed")
})
