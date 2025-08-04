#' Request a new ticket from causalbenchmarks.org
#'
#' @description
#' Requesting a ticket is the first stage of benchmarking a causal inference algorithm using causalbenchmarks org. 
#' A ticket allows you to request the generation of a dataset and gives you a unique URL at which to submit your results 
#' once your analysis has completed. The request_ticket function requests a new ticket given an algorithm key 
#' (a 32-character string available in your API dashboard). 
#' 
#' @param algorithm_key the 30-character algorithm key associated with the algorithm you are requesting a ticket for. 
#'  These tickets can be located in your API console at [causalbenchmarks.org/dashboard](causalbenchmarks.org/dashboard)
#'  
#' @return a 32-character ticket_id used in `get_dataset`, and `submit_estimate`. Please note that this is a secret value and should not be shared with anyone else. 
#' 
#' @importFrom httr2 request req_perform req_method resp_body_json
#' 
#' 
#' @export
get_new_ticket <- function(algorithm_key) {
  url <- paste0(get_base_url(), "new_ticket/", algorithm_key)
  
  req <- request(url) |>
    req_method("POST")
  
  response <- req_perform(req)
  ticket_id <- resp_body_json(response)
  
  ticket_id
}
