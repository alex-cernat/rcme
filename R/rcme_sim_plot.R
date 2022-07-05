#' Title
#'
#' @param rcme_sim_range_object Object saved by `rcme_ind()` or `rcme_out()` with multiple values.
#' @param ci include confidence interval in the graph
#' @param naive include naive estimate in the graph
#'
#' @return
#' @export
#'
#' @examples
#' ex <- rcme_out(
#'   formula = "damage_crime ~ collective_efficacy + unemployment +
#'   white_british + median_age",
#'   data = crime_damage,
#'   key_predictor = "collective_efficacy",
#'   S = c(0.29, 0.85, 1.0),
#'   R_sd = c(0.08, 0.10, 0.12),
#'   D = c(-0.3, -0.2, -0.1, 0),
#'   log_var = T)
#'
#' rcme_sim_plot(ex)
rcme_sim_plot <- function(rcme_sim_range_object,
                          ci = TRUE,
                          naive = TRUE) {

  # make plot
  plot_data <- rcme_sim_range_object$sim_result %>%
    dplyr::mutate(lci = key_predictor - (1.96 * SE),
           uci = key_predictor + (1.96 * SE))

  plot <- plot_data %>%
    ggplot2::ggplot(ggplot2::aes(D, key_predictor, fill = as.factor(R_sd))) +
    ggplot2::geom_line(ggplot2::aes(color = as.factor(R_sd),
                  linetype = as.factor(R_sd)), size = 0.7) +
    ggplot2::facet_wrap( ~ S) +
    ggplot2::theme_bw() +
    ggplot2::labs(
      x = "Correlation between key predictor and S",
      y = "Effect of key predictor on outcome",
      color = "Std. dev. random error",
      fill = "Std. dev. random error",
      linetype = "Std. dev. random error"
    ) +
    ggplot2::scale_color_brewer(palette = "PuBu") +
    ggplot2::scale_fill_brewer(palette = "PuBu")


  if (ci == T) {
    plot <- plot +
      ggplot2::geom_ribbon(ggplot2::aes(ymin = lci, ymax = uci), alpha = 0.05)

  }



  if (naive == T) {

    naive_coefs <- rcme_sim_range_object$naive$coefficients
    names(naive_coefs) <- stringr::str_remove_all(names(naive_coefs),
                                                  "log|\\(|\\)")

    naive_est <- naive_coefs[rcme_sim_range_object$key_predictor]

    naive_est_data <- data.frame(naive_est, R_sd = min(plot_data$R_sd))

    plot <- plot +
      ggplot2::geom_point(ggplot2::aes(
        x = 0,
        y = naive_est
      ),
      size = 3,
      alpha = 0.4) +
      ggrepel::geom_text_repel(data = naive_est_data,
                               ggplot2::aes(x = 0,
                                            y = naive_est,
                                            label = "Naive"),
                               box.padding = ggplot2::unit(0.35, "lines"),
                               point.padding = ggplot2::unit(0.3, "lines"),
                               alpha = 0.4) +
      ggplot2::guides(fill = ggplot2::guide_legend(override.aes = list(shape = NA)))

  }

  plot


}
