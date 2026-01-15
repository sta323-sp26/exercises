## Exercise 1

# Represent the following JSON data as a list in R.

str(list(
  "firstName" = "John",
  "lastName" = "Smith",
  "age" = 25,
  "address" =
    list(
      "streetAddress" = "21 2nd Street",
      "city" = "New York",
      "state" = "NY",
      "postalCode" = 10021
    ),
  "phoneNumber" = 
    list( list(
      "type" = "home",
      "number" = "212 555-1239"
    ),
      list(
      "type" = "fax",
      "number" = "646 555-4567"
    ) )
))



json = '{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25,
  "address": 
  {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": 10021
  },
  "phoneNumber": 
  [ {
      "type": "home",
      "number": "212 555-1239"
    },
    {
      "type": "fax",
      "number": "646 555-4567"
  } ]
}'

jsonlite::fromJSON(json, simplifyVector = FALSE) |> str()



## Demo

report = function(x) {
  UseMethod("report")
}
report.default = function(x) {
  paste0("Class ", class(x)," does not have a method defined.")
}
report.integer = function(x) {
  "I'm an integer!"
}
report.double = function(x) {
  "I'm a double!"
}
report.numeric = function(x) {
  "I'm a numeric!"
}

rm(report.integer)
#rm(report.double)
#rm(report.numeric)

report(1)
report(1L)
report("1")
