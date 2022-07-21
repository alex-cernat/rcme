#' Function simulating measurement error on an outcome variable
#'
#' @param data
#' @param outcome
#' @param S
#' @param key_predictor
#' @param R_sd
#' @param D
#'
#' @return
#' @export
#'
#' @examples
rcme_out_univar <- function(data,
                            outcome,
                            S,
                            key_predictor,
                            R_sd,
                            D) {
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

  data$adjusted

}


