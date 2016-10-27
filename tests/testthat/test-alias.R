suppressPackageStartupMessages(library(types))
context("type_alias")

test_that("testthat S3 methods aren't assigning", {
  type.numeric <- type_define(is.numeric)
  expect_true("type.numeric" %in% methods(type))
})

test_that("all type_alias argument styles work", {
  type.numeric <- type_define(is.numeric)
  expect_true("type.numeric" %in% methods(type))
  print(methods(type))

  type.n1 <- type_alias(type.numeric)
  type.n2 <- type_alias(numeric)
  type.n3 <- type_alias("type.numeric")
  type.n4 <- type_alias("numeric")


  f <- function(a = ? n1, b = ? n2, c = ? n3, d = ? n4) a + b + c + d
  ff <- type_check(f)

  expect_equal(ff(1, 1, 1, 1), 4)
  expect_error(ff(1, 1, 1, TRUE), "`d` is a `logical` not a `numeric`")
  expect_error(ff(1, 1, TRUE, 1), "`c` is a `logical` not a `numeric`")
  expect_error(ff(1, TRUE, 1, 1), "`b` is a `logical` not a `numeric`")
  expect_error(ff(TRUE, 1, 1, 1), "`a` is a `logical` not a `numeric`")
})

test_that("type_alias fails on undefined or incorrect types", {
  undefined <- list()
  type.undefined <- list()

  # type method without class "type"
  expect_error(type_alias(type.undefined), "undefined is not a type - cannot be aliased")
  # object without class "type"
  expect_error(type_alias(undefined), "undefined is not a type - cannot be aliased")
  # random string
  expect_error(type_alias("random_string"), "random_string is not a type - cannot be aliased")
  # unassigned object
  expect_error(type_alias(obj), "object 'obj' not found")
})


test_that("type_check with alias types", {
  type.numeric <- type_define(is.numeric)
  type.num <- type_alias(numeric)

  f <- function(x = ? num) x
  ff <- type_check(f)

  expect_error(ff("a"), "`x` is a `character` not a `numeric`")
  expect_error(ff(TRUE), "`x` is a `logical` not a `numeric`")
  expect_equal(ff(1), 1)
})
