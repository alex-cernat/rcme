# function for simulating ME when ME is on ind var.
#' Plotting graphs for
#'
#' @param data
#' @param outcome
#' @param predictors
#' @param S
#' @param key_predictor
#' @param R_sd
#' @param D
#' @param log_var
#'
#' @return
#' @export
#'
#' @examples
rcme_sim_ind <- function(data,
                    outcome,
                    predictors,
                    S,
                    key_predictor,
                    R_sd,
                    D,
                    log_var){

  lapply(0:1000, function(x){

    data$random_error <- rnorm(nrow(data), 0, R_sd)

    if (D != 0) {
      data$error_hat <- S + data$random_error * (1 - abs(D)) +
        (D * R_sd) / sd(data[[outcome]], na.rm = T) * data[[outcome]]
    } else {
      data$error_hat <- S + data$random_error
    }


    # Adding random error by setting its range of parameters
    #  equal to that of the R_sd of under reporting


    data$error_hat <- ifelse(data$error_hat < 0,
                                0.001,
                                ifelse(data$error_hat > 1,
                                       1,
                                       data$error_hat))

    data$adjusted <- data[[key_predictor]] / data$error_hat

    if (log_var == FALSE) {
	 if (length(predictors[!predictors %in% key_predictor]) > 0) {
        reg_syntax <- paste0(outcome, " ~ adjusted + ",
                             paste0(predictors[!predictors %in% key_predictor],
                                    collapse = " + "))
      } else {
        reg_syntax <- paste0(outcome, " ~ adjusted")
      }
    } else {
      if (length(predictors[!predictors %in% key_predictor]) > 0) {
        reg_syntax <- paste0(outcome, " ~ log(adjusted) + ",
                             paste0(predictors[!predictors %in% key_predictor],
                                    collapse = " + "))
      } else {
        reg_syntax <- paste0(outcome, " ~ log(adjusted)")
      }
    }


    lm(reg_syntax, data = data) %>%
      summary() %>%
      coef() %>%
      .[stringr::str_detect(rownames(.), "adjusted"), c("Estimate", "Std. Error")]
  })


}
