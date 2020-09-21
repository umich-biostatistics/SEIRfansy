## Load require packages

library(dplyr)
library(arm)
library(pbapply)
library(DescTools)
library("patchwork")
library(ggpubr)
library(ggplot2)

## Source function files

source("par_initializeR.R")
source("model_estimateR.R")
source("model_initializeR.R")
source("mcmc_performR.R")
source("model_deterministic_simulateR.R")
source("R0_calculateR.R")
source("model_predictR.R")
source("model_stochastic_simulateR.R")
source("model_plotR.R")

## Load data on Covid cases in India

data = read.csv(url("https://api.covid19india.org/csv/latest/case_time_series.csv"))
data = data %>%
  mutate(Current.Confirmed = Total.Confirmed - Total.Recovered - Total.Deceased)
# data_india=data
date_1_April= which(data$Date == "01 April ")
date_30_june= which(data$Date == "30 June ")
date_1_july = which(data$Date == "01 July ")
date_31_july = which(data$Date == "31 July ")
data_initial = data[date_1_April, ]
data_train = data[date_1_April:date_30_june, ]
data_test=data[date_1_july:date_31_july,]
obsP_tr <- data_train[,"Daily.Confirmed"] ## Daily Positive
obsR_tr <- data_train[,"Daily.Recovered"] ## Daily Recovered
obsD_tr <- data_train[,"Daily.Deceased"] ##  Daily Deaths
obsP_current_tr  = data_train[,"Current.Confirmed"] ## Current Confirmed
obsP_total_tr  = data_train[,"Total.Confirmed"] ## Total Confirmed

obsP_te <- data_test[,"Daily.Confirmed"] ## Daily Positive
obsR_te <- data_test[,"Daily.Recovered"] ## Daily Recovered
obsD_te <- data_test[,"Daily.Deceased"] ##  Daily Deaths
obsP_current_te  = data_test[,"Current.Confirmed"] ## Current Confirmed
obsP_total_te  = data_test[,"Total.Confirmed"] ## Total Confirmed
data_initial = c(2059, 169, 58, 424, 9, 11)
N = 1341e6 #population of India

mCFR = tail(cumsum(obsD_tr) / cumsum(obsD_tr+obsR_tr),1)

data_multinomial = data.frame("Confirmed" = obsP_tr, "Recovered" = obsR_tr, "Deceased" = obsD_tr)
data_test= data.frame("Confirmed" = obsP_te, "Recovered" = obsR_te, "Deceased" = obsD_te)
data_poisson = data.frame("Confirmed" = obsP_tr)

pars_start <- c(c(1,0.8,0.6,0.4,0.2), c(0.2,0.2,0.2,0.25,0.2))

phases = c(1,15,34,48,62)

################################################################################################################
### Run estimateR 
################################################################################################################

# (Run model_estimateR only if you want to only estimate and not predict)

Result = model_estimateR(data = data_multinomial,init_pars=pars_start,data_init = data_initial,
                        niter = 1e3, BurnIn = 1e2, model = "Multinomial", N = N, lambda = 1/(69.416 * 365),
                        mu = 1/(69.416 * 365), period_start = phases, opt_num = 1, auto.initialize=TRUE, f=0.15)

names(Result)
class(Result$mcmc_pars)
names(Result$plots)

################################################################################################################
### Run predictR 
################################################################################################################

# (model_predictR first runs model_estimateR and then predicts)

Result = model_predictR(data = data_multinomial,init_pars=pars_start,data_init = data_initial, T_predict = 60,
                        niter = 1e5, BurnIn = 1e5, data_test = data_test, model = "Multinomial", N = N, lambda = 1/(69.416 * 365),
                        mu = 1/(69.416 * 365), period_start = phases, opt_num = 1, auto.initialize=TRUE, f=0.15)

names(Result)
class(Result$prediction)
class(Result$mcmc_pars)
names(Result$plots)


saveRDS(Result$prediction,"Prediction.rds") 
saveRDS(Result$mcmc_pars,"mcmc_pars.rds")
saveRDS(Result,"Result.rds")