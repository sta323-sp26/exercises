## Excise 1

f = function(x) {
  # Check small prime
  if (x > 10 || x < -10) {
    stop("Input too big")
  } else if (x %in% c(2, 3, 5, 7)) {
    cat("Input is prime!\n")
  } else if (x %% 2 == 0) {
    cat("Input is even!\n")
  } else if (x %% 2 == 1) {
    cat("Input is odd!\n")
  }
}

f(1)      # x
f(3)      # x
f(-1)     # x
f(-3)     # x
f(1:2)    # `||` based error 
f("0")    # `%%` error
f("zero") # `> 10` error  


## Exercise 2

primes = c( 2,  3,  5,  7, 11, 13, 17, 19, 23, 
            29, 31, 37, 41, 43, 47, 53, 59, 61, 
            67, 71, 73, 79, 83, 89, 97)

x = c(3,4,12,19,23,51,61,63,78)

for (x in c(3,4,12,19,23,51,61,63,78)) {
  is_prime = FALSE
  
  for (p in primes) {
    if (x == p) {
      is_prime = TRUE
      break
    } 
  }
  
  if (!is_prime)
    print(x)
}


### A slightly more compact and efficient implementation
x[!x %in% primes]





