
#' COVID-19 Cases Time Series in India
#'
#' Contains dailies and totals of cases, recoveries, and deaths from the COVID-19 
#' outbreak in India from January 30 to September 21 of 2020.
#' 
#' @format An object of class `data.frame` with 236 rows and 7 columns.
#' 
#' \describe{
#'   \item{Date}{Date as a character string}
#'   \item{Daily.Confirmed}{Daily confirmed cases as an integer vector}
#'   \item{Total.Confirmed}{Total confirmed cases upto current date as an integer vector}
#'   \item{Daily.Recovered}{Daily recovered cases an an integer vector}
#'   \item{Total.Recovered}{Total confirmed cases upto current date as an integer vector}
#'   \item{Daily.Deceased}{Daily deceased cases as an integer vector}
#'   \item{Total.Deceased}{Total deceased cases upto current date as an integer vector}
#' }
#'
#' @examples
#' covid19
#' head(covid19)
#' tail(covid19)
"covid19"