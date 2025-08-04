#' Request a new ticket from causalbenchmarks.org
#'
#' @description
#' Requesting a ticket is the first stage of benchmarking a causal inference algorithm using causalbenchmarks org. 
#' A ticket allows you to request the generation of a dataset and gives you a unique URL at which to submit your results 
#' once your analysis has completed. The request_ticket function requests a new ticket given an algorithm key 
#' (a 32-character string available in your API dashboard). 
#' 
#' @param ticket_id a 32-character ticket_id supplied by `get_ticket`. Please note that this is a secret value and should not be shared with anyone else.
#'  
#' @return 
#' 
#' @importFrom httr2 request req_perform req_method resp_body_json req_body_json
#' @importFrom tibble tibble
#' 
#' 
#' @export
submit_estimate <- function(ticket_id, estimate, ci_lo = NULL, ci_hi = NULL) {
  answer_endpoint <- paste0(get_base_url(), "submit/", ticket_id)
  
  estimate_req <- request(answer_endpoint) |>
    req_method("POST") |>
    req_body_json(
      list(estimate = list(estimate))
    )
  
  resp_data <- req_perform(estimate_req) |>
    resp_body_json()
  
  out <- tibble(
    estimate = as.numeric(resp_data$estimate),
    ground_truth = as.numeric(resp_data$ground_truth),
    mse = as.numeric(resp_data$mse),
    total_mse = as.numeric(resp_data$total_mse),
    time_s = as.numeric(resp_data$time_s)
  )
  
  if (is.null(resp_data$ci_lo)) {
    out$ci_lo <- NA
    out$ci_hi <- NA
  } else {
    out$ci_lo <- as.numeric(resp_data$ci_lo)
    out$ci_hi <- as.numeric(resp_data$ci_hi)
  }
  
  out
  
}



