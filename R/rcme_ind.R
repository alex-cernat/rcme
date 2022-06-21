
# function to run simulation for one situation
#' Function that simulates the effect of measurement error on an independent variable.
#'
#' @param formula Regression formula of interest
#' @param data Data that will be used
#' @param key_predictor The key independent variable of interest in the model. Only one variable can be used.
#' @param S The magnitude of the systematic error component, included as a scalar contained within the (0,1). Users can input multiple values using c().
#' @param R_sd The magnitude of the random errors, included as a value of the standard deviation, assumed to be normally distributed with a mean of zero. Users can input multiple values using c().
#' @param D The magnitude of the correlation between the measurement error and the key variable of interest. Users can input multiple values using c().
#' @param log_var Do you want the function to log the outcome? If log_var = TRUE users must remember that all sensitivity results will be presented on the log scale.
#'
#' @return
#' @export
#'
#' @examples
#' rcme_ind(
#'   formula = "disorder ~ log_violent_crime + white_british + unemployment + median_age",
#'   data = crime_disorder,
#'   key_predictor = "log_violent_crime",
#'   S = 0.31,
#'   R_sd = 0.12,
#'   D = -0.1)
rcme_ind <- function(formula,
                      data, # data to use
                      key_predictor, # main predictor of interest
                      S = 1, # reporting rate
                      R_sd = 0, # standard deviation to use
                      D = 0, # correlation
                      log_var = FALSE # should we log the variable


) {


# input checks ------------------------------------------------------------

  # check inputs and give error if not correct format and length
  if (!is.data.frame(data)) {
    stop("`data` must be a data")
  }
  if (!is.numeric(S)) {
    stop("`S` must be numeric and of length 1")
  }
  if (sum(S < 0, S > 1) > 0) {
    stop("`S` must be between 0 and 1")
  }
  if (!is.numeric(R_sd)) {
    stop("`R_sd` must be numeric and of length 1")
  }
  if (!is.numeric(D)) {
    stop("`D` must be numeric and of length 1")
  }
  if (sum(D < -1, D > 1) > 0) {
    stop("`D` must be between -1 and 1")
  }
  if (length(key_predictor) != 1 | !is.character(key_predictor)) {
    stop("`key_predictor` must be character and of length 1")
  }
  if (is.logical(log_var) == FALSE) {
    stop("`log_var` must be logical type")
  }
  if (length(log_var) == 1) {
    if (log_var == TRUE) {
      warning("You have specified log_var = TRUE.\nThe crime variable will be logged to reflect the multiplicative error structure. If you wish to report the sensitivity results in the original crime metric they will need to be transformed. For a full discussion of the multiplicative error structure of crime see Pina-Sanchez et al., 2022.")
    }
  }
  if (length(D) == 1) {
    if (D == 0) {
      warning("The correlation between measurement error in crime data and the key variable of interest is set to 0. Non-differentiality is assumed.")
    }
  }


# parse inputs ------------------------------------------------------------


  # parse formula to separate outcome and ind. vars
  formula_info <- stringr::str_split(formula, "~")[[1]]

  # get outcome
  outcome <- stringr::str_trim(formula_info[1])

  # save predictors as separate object
  predictors <- stringr::str_split(formula_info[2], "\\+")[[1]] %>%
    stringr::str_trim()

  # check if all the variables are in the data
  all_vars <- c(outcome, predictors)
  name_check <- all_vars %in% names(data)
  if (sum(name_check) < length(all_vars)) {
    stop(paste("The following variables are not in the data:",
               all_vars[!name_check]))
  }


# make naive estimation ---------------------------------------------------

  # make different naive estimation depending if the variable should be logged
  # or not
  if (sum(log_var) == F) {
    lm_naive <- lm(paste0(outcome, " ~ ",
                          paste0(
                           c(paste0(key_predictor, collapse = ""),
                             predictors[!predictors %in% key_predictor]),
                           collapse = " + ")),
                   data)
  } else {
    lm_naive <- lm(paste0(outcome, " ~ ",
                          paste0(
                           c(paste0("log(", key_predictor, ")",
                                            collapse = ""),
                             predictors[!predictors %in% key_predictor]),
                           collapse = " + ")),
                   data)
  }



# run simulation ----------------------------------------------------------


  # if only one set of inputs run function just once. If more run multiple times
  if (length(S) + length(R_sd) +
      length(D) + length(log_var) == 4) {

    # run sim_ind function once with inputs from above
    sim_res <- rcme_sim_ind(data,
                       outcome,
                       predictors,
                       S,
                       key_predictor,
                       R_sd,
                       D,
                       log_var)

    # extract inputs from simulation
    slope <- purrr::map(sim_res, function(x) x["Estimate"]) %>%
      unlist() %>%
      mean()
    SE <- purrr::map(sim_res, function(x) x["Std. Error"]) %>%
      unlist() %>%
      mean()

    # save simple results for printing
    sim_result <- data.frame(key_predictor = round(slope, 3),
                             SE = round(SE, 3))

  } else {

    # create all possible combination of inputs to loop over
    args <- expand.grid(S = S,
                        R_sd = R_sd,
                        D = D,
                        log_var = log_var)

    # loop function over all combination of inputs
    res <- purrr::pmap(args,
                       rcme_sim_ind,
                       data = data,
                       predictors = predictors,
                       outcome = outcome,
                       key_predictor = key_predictor)

    # extract inputs from simulation
    slope <- purrr::map_dbl(res, function(x) {
      purrr::map(x, function(y) y["Estimate"]) %>% unlist() %>% mean()
    })
    SE <- purrr::map_dbl(res, function(x) {
      purrr::map(x, function(y) y["Std. Error"]) %>% unlist() %>% mean()
    })

    # save simple results for printing
    sim_result <- cbind(args,
                        key_predictor = round(slope, 3),
                        SE = round(SE, 3))
  }


# save result -------------------------------------------------------------

  # make list object to print
  out <- list(sim_result = sim_result,
              naive = lm_naive,
              key_predictor = key_predictor)

  # print result
  out

}
