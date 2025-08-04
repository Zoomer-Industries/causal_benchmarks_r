.api_env <- new.env(parent = emptyenv())

.api_env$base_url <- "https://api.causalbenchmarks.org/"

get_base_url <- function() {
  .api_env$base_url
}