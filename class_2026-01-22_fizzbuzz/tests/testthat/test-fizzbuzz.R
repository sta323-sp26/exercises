test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})



test_that("print_summary produces consistent output", {
  df = data.frame(x = 1:3, y = letters[1:3])
  expect_snapshot({
    print_summary(df)
  })
})
