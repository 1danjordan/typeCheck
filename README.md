
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Type Check

Type check allows use of [types](https://github.com/jimhester/types) to
automatically add checking code when types are annotated.  
See also [typed](https://github.com/1danjordan/typed) for a number of
pre-defined common types to be used with `typeCheck`.

☞ **[This fork of typeCheck](https://github.com/alekrutkowski/typeCheck)
adds one simple convenience wrapper `type_define_lambda` on top of
`type_define`:**

``` r
# The two type definitions below are identical:

type.my_string_scalar1 <- 
  type_define_lambda( is.character(.) && length(.)==1 )

type.my_string_scalar2 <- 
  type_define( function(.)
                      is.character(.) && length(.)==1 )
```

☞ **Use the dot (`.`) to refer to the parameter of the checking
function.**

### Defining Types

`type_define()` is used to define a new type. The `check` argument
specifies a function used to verify the objects type. `type_check` adds
the checks to a specific function.

``` r
type.numeric <- type_define(check = is.numeric)
#> Error in type_define(check = is.numeric): could not find function "type_define"

f <- type_check(function(x = ? numeric) x)
#> Error in type_check(function(x = `?`(numeric)) x): could not find function "type_check"
f(1)
#> Error in f(1): could not find function "f"
f("txt")
#> Error in f("txt"): could not find function "f"
```

Types are defined as methods of the `type` generic. This means they
follow the same properties as normal S3 methods and can be exported and
imported to and from packages like all other functions.

The `error` argument is used to specify a custom error message for a
type.

``` r
type.numeric <- type_define(
  check = is.numeric,
  error = function(obj_name, obj_value, type) {
     sprintf("%s: '%s' is not a number!", obj_name, obj_value)
  })
#> Error in type_define(check = is.numeric, error = function(obj_name, obj_value, : could not find function "type_define"
f <- type_check(function(x = ? numeric) x)
#> Error in type_check(function(x = `?`(numeric)) x): could not find function "type_check"
f("txt")
#> Error in f("txt"): could not find function "f"
```

### Packages

When writing a package adding a call to
`typeCheck::type_check_package()` anywhere outside a function will add
type checks to all functions in the package. Functions without type
annotations are unaltered.

This means it is easy to add annotations in a stepwise process to
existing packages.

If you are using [roxygen2](https://github.com/klutometis/roxygen) You
can use the following `importFrom` statement (or use the equivalent
`importFrom()` call directly in the `NAMESPACE` file.)

``` r
f <- function(x = ? numeric) x

#' @importFrom typeCheck type type_define
typeCheck::type_check_package()
```
