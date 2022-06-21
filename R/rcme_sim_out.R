# function for simulating ME when ME is on outcome var.
#' Title
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
rcme_sim_out <- function(data,
                    outcome,
                    predictors,
                    S,
                    key_predictor,
                    R_sd,
                    D,
                    log_var
){

  lapply(0:1000, function(x){
    data$random_error <- rnorm(nrow(data), 0, R_sd)

    if (D != 0) {
    data$error_hat <- S + data$random_error * (1 - abs(D)) +
      (D * R_sd) / sd(data[[key_predictor]], na.rm = T) * data[[key_predictor]]
    } else {
    data$error_hat <- S + data$random_error
      }


    # Adding random error by setting its range of parameters
    #  equal to that of the sd of under reporting


    data$error_hat <- ifelse(data$error_hat < 0,
                                 0.001,
                                 ifelse(data$error_hat > 1,
                                        1,
                                        data$error_hat))

    data$adjusted <- data[[outcome]] / data$error_hat

    if (log_var == FALSE) {
      reg_syntax <- paste0("adjusted ~ ",
                           paste0(predictors, collapse = "  + "))
    } else {
      reg_syntax <- paste0("log(adjusted) ~ ",
                           paste0(predictors, collapse = "  + "))
    }



    lm(reg_syntax, data = data) %>%
      summary() %>%
      coef() %>%
      .[key_predictor, c("Estimate", "Std. Error")]
  })
}
