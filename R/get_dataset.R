#' Get the dataset associated with a ticket_id
#' 
#' @description
#' Getting a dataset is the second stage in analyzing a simulation from 
#' causalbenchmarks.org. Once you have received a ticket_id from `get_new_ticket`
#' , you can use this function to download the dataset to analyze. 
#' Requesting a dataset stars a timer that runs until the results 
#' of the analysis are submitted, in order to track the speed of your algorithm.
#' 
#' @param ticket_id a 32-character ticket_id supplied by `get_ticket`. Please note that this is a secret value and should not be shared with anyone else. 
#'
#' @return a dataframe containing the data associated with this simulation
#' 
#' @importFrom httr2 request req_method req_perform resp_body_raw 
#' @importFrom readr read_csv
#' @export
get_dataset <- function(ticket_id) {
  data_endpoint <- paste0(get_base_url(), "get_data/csv/", ticket_id)
  
  csv_resp <- request(data_endpoint) |>
    req_method("POST") |>
    req_perform()
  
  dataset <- read_csv(resp_body_raw(csv_resp))
}