test_that("get_list returns a tibble", {
  expect_s3_class(get_list("series"), class = "tbl")
  expect_s3_class(get_list("groups"), class = "tbl")
})

test_that("get_list returns correct categories", {
  expect_named(get_list("groups"),
               c("name", "label", "description", "link"))
  expect_named(get_list("series"),
               c("name", "label", "description", "link"))
  expect_true(all(sapply(get_list("groups")$link, function(x) substr(x, 1, 5) == "https")))
  expect_true(all(sapply(get_list("series")$link, function(x) substr(x, 1, 5) == "https")))
})
