
#' Prediction for SEIRfansy Model
#' 
#' This function is used to predict the total reported as well as unreported case 
#' counts, total recovered, and total deaths.
#'
#' @param data (mandatory): input the training data set. If the model is 
#' Multinomial then the data matrix should contain the 3 columns Confirmed, 
#' Recovered, and Death. If the model is Poisson or Binomial, then the data 
#' should contain only the column Confirmed. Note that the names of 
#' the columns must be the same as stated above.
#' @param data_init (mandatory): These are the initial data values 
#' provided by the user as a numeric vector of length six. The entries should be 
#' the Total Confirmed, Total Recovered, Total Death, Daily Confirmed,
#' Daily Recovered, and Daily Death for the Starting Date. Note: If the starting total 
#' confirmed is 0, please replace it by 1.
#' @param init_pars NULL (default): If not equal to NULL, then the user can give a user input initial 
#' parameters which should consist of the initial values of the time varying beta, 
#' proportion of testing for the different periods.
#' @param N (mandatory): The population size.
#' @param plot TRUE (default): If estimate = FALSE, this will give two plots. One is 
#' the panel plot for total cases, total recovered, total death, and total 
#' confirmed if the model is Multinomial. Otherwise it will give only a plot for total 
#' confirmed when the model is binomial or Poisson, and the second plot is the plot 
#' of untested, false negative, and reported cases. And when estimate = TRUE, 
#' it will give two other plots along with the previous two plots. One is the 
#' box plot for basic reproduction number and the other one is the trace plot for 
#' the convergence of the MCMC parameters.
#' @param T_predict It is the number of days that we want to predict after the train 
#' period. The value of T_predict should be greater than or equal to the number 
#' of rows of `data_test`.
#' @param period_start The total time period is divided into small periods depending 
#' on the lock down measures imposed by the government. So this is a numeric vector consisting 
#' of the start dates for the different time periods.
#' @param estimate TRUE (default): If it is TRUE then it will run the MCMC algorithm 
#' to estimate the parameters. If it is FALSE, then the user needs to give 
#' input the parameter values in the pars argument.
#' @param pars = NULL (default): If estimate = FALSE, then the user needs to 
#' input the parameter estimates.
#' @param data_test NULL (default): Otherwise need to give the 
#' test data for comparing with the model estimates.
#' @param auto.initialize TRUE (default): This is the option for using a mle 
#' based initial parameter.
#' @param ... arguments passed to the function SEIRfansy, model_initializeR 
#' and model_plotR which are used for initializing the parameters. The 
#' parameters are described below:
#'            \itemize{
#'                 \item{niter: }{1e5 (default): Number of iteration for the MCMC 
#'                 metropolis hasting algorithm.}
#'                 \item{BurnIn: }{5e4 (default) This is the Burn-In Period for 
#'                 the MCMC algorithm.}
#'                 \item{model: }{"Multinomial" (default): This is the likelihood 
#'                 function that will be used. There are three options available 
#'                 including "Multinomial", "Poisson", and "Binomial".}
#'                 \item{alpha_p: }{0.5 (default): It is defined as the ratio of 
#'                 rate of spread of infection by tested positive patients to that 
#'                 by false negatives. We have taken $alpha_p < 1$ as patients 
#'                 who are tested positive are subjected to quarantine where the 
#'                 chance of spreading the disease is less than that of false 
#'                 negative patients who are mostly unaware of their infectious nature. 
#'                 So, false negative individuals continue to spread the disease 
#'                 freely at a higher rate than tested positive individuals.}
#'                 \item{alpha_u: }{0.7 (default): It is defined as the  scaling 
#'                 factor for the rate of spread of infection by untested individuals. 
#'                 $alpha_u$ is assumed to be < 1 as U mostly consists of 
#'                 asymptomatic or mildly symptomatic cases who are known to spread 
#'                 the disease at a much lower rate than those with higher levels 
#'                 of symptoms.}
#'                 \item{beta_1: }{0.6 (default): It is the scaling factor for 
#'                 rate of recovery  for untested individuals. $beta_1$ is  
#'                 assumed to be less than 1. The condition of Untested individuals 
#'                 is not so severe as they consist of mostly asymptomatic people. 
#'                 So, they are assumed to recover faster than the Current Positive ones.}
#'                 \item{beta_2: }{0.7 (default): It is the inverse of the scaling 
#'                 factor for rate of recovery for false negative individuals.  
#'                 $beta_2$ is assumed to be less than 1. It is assumed that the 
#'                 recovery rate is slower than the detected ones for the False 
#'                 Negative ones because they are not getting any hospital 
#'                 treatment.}
#'                 \item{delta_1: }{0.3 (default): It is the scaling factor for 
#'                 death rate for undetected individuals. $delta_1$ is assumed 
#'                 to be less than 1. Similarly, for the Untested ones, the death 
#'                 rate is taken to be lesser because they are mostly asymptomatic. 
#'                 So, their probability of dying is much less.}
#'                 \item{delta_2: }{0.7 (default): It is the inverse of the scaling 
#'                 factor for death rate for false negative individuals. $delta_2$ 
#'                 is assumed to be less than 1. Same as before, the death rate for 
#'                 False Negative ones are assumed to be higher than the Current 
#'                 detected Positive as they are not receiving proper treatment.}
#'                 \item{lambda: }{1 / (66.26 * 365) (default): Natural birth rate. 
#'                 The value given here as the default value is the world's common 
#'                 birth  rate.}
#'                 \item{mu: }{1 / (66.26 * 365) (default): Natural death rates. 
#'                 This is assumed to be equal with natural birth rate for the 
#'                 sake of simplicity.}
#'                 \item{D_e: }{5.2 (default): Incubation period.}
#'                 \item{Dr: }{17.8 (default): Mean days until recovery for positive 
#'                 individuals.}
#'                 \item{f: }{0.15 (default): False negative probability of RT-PCR 
#'                 test.}
#'                 \item{mCFR: }{NULL (default): (It is calculated from the data by default) 
#'                 It is defined as the ratio of the total reported deceased cases 
#'                 and the total removed cases until that day.}
#'                 \item{init.exposed.ratio: }{3 (default): This is the scaling 
#'                 factor for the calculation of the initial number of exposed 
#'                 people from the sum of the initial number of unreported, 
#'                 reported people.}
#'                 \item{init.confirmed.ratio: }{0.15 (default): This is the initial 
#'                 value of the probability of being tested.}
#'                 \item{opt_num: }{100 (default): The number of times an user 
#'                 wants to run the mle optimization before deciding on the best 
#'                 initial parameter.}
#'                 \item{trace_plot.common_axis: }{FALSE (default): This will give 
#'                 the trace plot for the convergence of the MCMC estimated time 
#'                 varying parameters.}
#'                 \item{save plot: }{TRUE (default): It is the option for saving 
#'                 the plots in the directory folder.}}
#'
#' @return A list with class "SEIRfansyPredict", which contains the items described 
#' below:
#' \itemize{
#'   \item{mcmc_pars: }{a matrix of the mcmc draws for the parameters}
#'   \item{plots: }{a list of ggplot objects}
#' }
#' @export
#'
#' @examples
#' library(dplyr)
#' train = covid19[which(covid19$Date == "01 April "):which(covid19$Date == "30 June "),]
#' test = covid19[which(covid19$Date == "01 July "):which(covid19$Date == "31 July "),]
#' 
#' train_multinom = 
#'  train %>% 
#'    rename(Confirmed = Daily.Confirmed, 
#'           Recovered = Daily.Recovered,
#'           Deceased = Daily.Deceased) %>%
#'    dplyr::select(Confirmed, Recovered, Deceased)
#'  
#'  test_multinom = 
#'    test %>% 
#'    rename(Confirmed = Daily.Confirmed, 
#'           Recovered = Daily.Recovered,
#'           Deceased = Daily.Deceased) %>%
#'    dplyr::select(Confirmed, Recovered, Deceased)
#'  
#' N = 1341e6 # population size of India
#' data_initial = c(2059, 169, 58, 424, 9, 11)
#' pars_start = c(c(1,0.8,0.6,0.4,0.2), c(0.2,0.2,0.2,0.25,0.2))
#' phases = c(1,15,34,48,62)
#'  \donttest{
#'  cov19pred = SEIRfansy.predict(data = train_multinom, init_pars = pars_start, 
#'                                data_init = data_initial, T_predict = 60, niter = 1e3, 
#'                                BurnIn = 1e2, data_test = test_multinom, model = "Multinomial", 
#'                                N = N, lambda = 1/(69.416 * 365), mu = 1/(69.416 * 365), 
#'                                period_start = phases, opt_num = 1, 
#'                                auto.initialize = TRUE, f = 0.15)
#' 
#' names(cov19pred)
#' class(cov19pred$prediction)
#' class(cov19pred$mcmc_pars)
#' names(cov19pred$plots)
#' 
#' plot(cov19pred, type = "trace")
#' plot(cov19pred, type = "boxplot")
#' plot(cov19pred, type = "panel")
#' plot(cov19pred, type = "cases")
#' }
#' 
#' # quick test for package check
#' cov19est = SEIRfansy(data = train_multinom, init_pars = pars_start, 
#'                      data_init = data_initial, niter = 103, BurnIn = 23, 
#'                      model = "Multinomial", N = N, lambda = 1/(69.416 * 365), 
#'                      mu = 1/(69.416 * 365), period_start = phases, opt_num = 1, 
#'                      auto.initialize = TRUE, f = 0.15, plot = FALSE)
#' 
#' 

SEIRfansy.predict <- function(data=NULL, data_init, init_pars = NULL, N, plot = TRUE, T_predict, period_start, estimate = TRUE,
                              pars = NULL, data_test = NULL, auto.initialize = TRUE, ... ){
  if(estimate == FALSE && is.null(pars)) stop("Either supply parameters or set estimate = TRUE")
  if(estimate == FALSE){
    mcmc_pars = matrix(pars,nrow=1)
  }  else{
    cat("Estimating ... ", fill = TRUE)
    cat("  ", fill = TRUE)
    mcmc_estimate = SEIRfansy(data = data, data_init = data_init, init_pars = init_pars, N = N,
                                    period_start = period_start, plot = plot, auto.initialize = auto.initialize,...)
    mcmc_pars = mcmc_estimate$mcmc_pars
    if(plot == TRUE) plots_estimateR = mcmc_estimate$plots
  }
  var_init = model_initializeR(data = data, data_init = data_init, init_pars = NULL, N = N,
                               auto.initialize = FALSE, period_start = period_start, override = TRUE, ...)

  fix_pars = var_init$fix_pars
  init_state_num = var_init$init_state_num
  period_start = var_init$period_start

  #library(pbapply)
  cat(" ", fill = TRUE)
  cat("Predicting ... ", fill = TRUE)
  pboptions(type="txt", char="|")
  T_train=ifelse(is.null(data),0,nrow(data))
  prediction <- pbapply(matrix(mcmc_pars[, 1:(2*length(period_start))],nrow=nrow(mcmc_pars)), 1, function(x)
    model_stochastic_simulateR(init_obs_current = init_state_num, init_obs_daily = data_init[4:6], period_start = period_start,
                               times = 1:(T_train+T_predict), pars = x, fix_pars = fix_pars, ...))
  Result = list(prediction = prediction)

  if(estimate == TRUE)
    Result$mcmc_pars = mcmc_pars

  ### Plot

  if(plot == TRUE){
    T_simu = T_predict + nrow(data)
    plots_predictR <- model_plotR(Result = Result, T_predict = T_predict, T_simu = T_simu, n_period = n_period,
                                  data = data, data_test = data_test, data_initial = data_initial,
                                  call = "predictR", ...)
    Result$plots = c(plots_estimateR, plots_predictR)
    class(Result) = "SEIRfansyPredict"
    return(Result)
  }

  class(Result) = "SEIRfansyPredict"
  return(Result)

}

