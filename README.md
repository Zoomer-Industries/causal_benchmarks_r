
# Causal Benchmarks API Wrapper

`causalbenchmarks` is an R package that provides convenient functions to
interface with the [causalbenchmarks.org](https://causalbenchmarks.org)
API.

## Getting started

To begin using the package, you will need to have an algorithm key,
which you can obtain from the [causalbenchmarks
dashboard](https://causalbenchmarks.org/dashboard). An algorithm key is
an API key specific to an individual causal inference algorithm and is
used to request new data analysis tasks. Like other API keys, it should
not be shared publicly.

If you are unsure whether you would like to make an account, or just
would like to experiment with the package, you can also use the testing
algorithm key, `ABCDEFGHIJKLMNOPQRSTUVWXYZ1234`. This is a special
algorithm for the `rct_100` task which will never show up on the
leaderboards, but it will allow you to experiment with the API. You can
check out some details about the test algorithm
[here](https://causalbenchmarks.org/algorithm/TEST_ALGORITHM)

## Step 1: Request a New Ticket

Once you have your algorithm key, you can request a data analysis
ticket. A ticket is a unique identifier associated with a simulation,
and provides a way to request a dataset and submit the results of your
analysis once your algorithm has run. To request a ticket, we use the
`get_new_ticket` function which returns a new ticket for the algorithm
associated with the submitted algorithm key.

If we print out the ticket id, we see it is another 30-character
identifier, just like the algorithm key. However, this key is specific
to this simulation, and will only be used to request a dataset and
submit the analysis.

``` r
ticket_id <- get_new_ticket("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234")
print(ticket_id)
```

    ## [1] "Q068MC72NZACE2APL955GV9W3VEFBVOD"

## Step 2: Request the Dataset

Now that we have a new data analysis ticket, we can ask for a dataset
and begin our analysis using the `get_dataset` function in conjunction
with the ticket identifier. Because submissions to
[causalbenchmarks.org](https://causalbenchmarks) are timed, requesting
this dataset starts a timer which is stopped when we submit our answer
to the data analysis task.

``` r
data <- get_dataset(ticket_id)
print(head(data))
```

    ## # A tibble: 6 × 2
    ##   treatment outcome
    ##   <lgl>       <dbl>
    ## 1 TRUE       -1.15 
    ## 2 FALSE       0.101
    ## 3 FALSE       0.721
    ## 4 TRUE        1.76 
    ## 5 TRUE        2.26 
    ## 6 FALSE       2.17

## Step 3: Run your Algorithm

Once we have the dataset, we can run our analysis. In this case, we are
going to use linear regression to estimate the difference in group means
and come up with standard errors for our treatment effect estimates
using the `lm` function. In practice, you would perform your own data
analysis here with your own algorithm.

``` r
# estimate treatment effect via difference in group means
linear_model <- lm(outcome~treatment, data = data) 
# extract our answer from the models' coefficients
estimate <- coef(linear_model)[2]
estimate
```

    ## treatmentTRUE 
    ##    -0.8096168

# Step 4: Submit your results

With our estimate in hand, we can then submit our answer to the API for
benchmarking. The `submit_estimate` function takes in the ticket_id,
estimate and optionally, a lower bound and upper bound on the 95%
confidence interval for our estimate. The function returns a tidy
benchmark of statistics so we can see how we did! These statistics are
also available online and if you have made your algorithm public, they
will show up on the leaderboard if you are in the top 50 algorithms for
a task!

``` r
submit_estimate(ticket_id, estimate)
```

    ## # A tibble: 1 × 7
    ##   estimate ground_truth     mse total_mse time_s ci_lo ci_hi
    ##      <dbl>        <dbl>   <dbl>     <dbl>  <dbl> <lgl> <lgl>
    ## 1   -0.810       -0.877 0.00451   0.00451  0.189 NA    NA
