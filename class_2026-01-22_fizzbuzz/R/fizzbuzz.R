#' @title Fizzbuzz function
#'
#' @description
#' A short description...
#'
#' @param x *Numeric* vector to use for the fizzbuzz function
#'
#' @returns Returns a *character* vector of values, "fizz", "buzz", or "fizzbuzz"
#'
#' @examples
#' fizzbuzz(1:10)
#' fizzbuzz(10:1)
#'
#' @export
#'
fizzbuzz = function(x) {
  stopifnot(all(x>0))
  stopifnot(all(is.finite(x)))
  stopifnot(is.numeric(x))

  dplyr::case_when(
    x %% 3 == 0 & x %% 5 == 0 ~ "fizzbuzz",
    x %% 3 == 0 ~ "fizz",
    x %% 5 == 0 ~ "buzz",
    TRUE ~ as.character(x)
  )
}

hello = function(x) {
  print(c("Hello,", x,"!"))
}



print_summary = function(data) {
  cat("Data summary:\n")
  cat("Rows:", nrow(data), "\n")
  cat("Columns:", ncol(data), "\n")
  cat("Column names:", paste(names(data), collapse = ", "), "\n")
  cat("...\n")
}
