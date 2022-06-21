#' Synthetic data of criminal damage rates and collective efficacy.
#'
#' A dataset containing criminal damage rates, collective efficacy measures
#' and other socio-demographic variables for 250 areas.
#'
#' This dataset was generated following multivariate normal distributions
#' to replicate real-world parameters recorded in the UK Census 2011 and
#' the Metropolitan Police Service Public Attitudes Survey 2011-2013 at 
#' the level of Middle layer Super Output Areas (MSOAs) in London.
#'
#' @format A data frame with 250 rows and 6 variables:
#' \describe{
#'   \item{collective_efficacy}{collective efficacy estimates, standardised}
#'   \item{unemployment}{unemployment rates, standardised}
#'   \item{median_age}{median age, standardised}
#'   \item{white_british}{proportion of White British residents, standardised}
#'   \item{damage_crime}{criminal damage rate per 1,000 pop}
#'   \item{log_damage_crime}{criminal damage rate per 1,000 pop, log-transformed}
#' }
#' @source \url{https://github.com/alex-cernat/rcme/tree/master/data}
"crime_damage"


#' Synthetic data of perceived disorder and violent crime rates.
#'
#' A dataset containing perceived disorder measures, violent crime rates
#' and other socio-demographic variables for 250 areas.
#' 
#' This dataset was generated following multivariate normal distributions
#' to replicate real-world parameters recorded in the UK Census 2011 and
#' the Crime Survey for England and Wales 2011/12 at the level of Local
#' Authorities in England and Wales.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{violent_crime}{violent crime rate per 1,000 pop}
#'   \item{white_british}{proportion of White British residents, standardised}
#'   \item{unemployment}{unemployment rates, standardised}
#'   \item{median_age}{median age, standardised}
#'   \item{disorder}{perceived disorder estimates, standardised}
#'   \item{log_violent_crime}{violent crime rate per 1,000 pop, log-transformed}
#' }
#' @source \url{https://github.com/alex-cernat/rcme/tree/master/data}
"crime_disorder"