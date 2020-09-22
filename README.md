
<!-- README.md is generated from README.Rmd. Please edit that file -->

# R package `SEIRfansy`

# Extended Susceptible-Exposed-Infected-Recovery Model

[![](https://img.shields.io/badge/devel%20version-1.0.0.9000-blue.svg)](https://github.com/umich-biostatistics/SIERfansy)
[![](https://img.shields.io/github/languages/code-size/umich-biostatistics/SEIRfansy.svg)](https://github.com/umich-biostatistics/SEIRfansy)

## Overview

This `R` package fits Extended Susceptible-Exposed-Infected-Recovery
(SEIR) Models for handling high false negative rate and symptom based
administration of diagnostic tests.

## Installation

If the devtools package is not yet installed, install it first:

``` r
install.packages('devtools')
```

``` r
# install SEIRfansy from Github:
devtools::install_github('umich-biostatistics/SEIRfansy') 
library(SEIRfansy)
```

## Example Usage

For this example, we use the built-in package data set `covid19`, which
contains dailies and totals of cases, recoveries, and deaths from the
COVID-19 outbreak in India from January 30 to September 21 of 2020.

### Setup

You will need the `dplyr` package for this example.

``` r
library(dplyr)
```

Training data set:

For training data, we use cases from April 1 to June 30

``` r
train = covid19[which(data$Date == "01 April "):which(data$Date == "30 June "),]
```

Testing data set:

For testing data, we use cases from July 1 to July 31

``` r
test = covid19[which(data$Date == "01 July "):which(data$Date == "31 July "),]
```

Data format for multinomial and Poisson distribution:

``` r
train_multinom = 
  train %>% 
  rename(Confirmed = Daily.Confirmed, 
         Recovered = Daily.Recovered,
         Deceased = Daily.Deceased) %>%
  select(Confirmed, Recovered, Deceased)

test_multinom = 
  test %>% 
  rename(Confirmed = Daily.Confirmed, 
         Recovered = Daily.Recovered,
         Deceased = Daily.Deceased) %>%
  select(Confirmed, Recovered, Deceased)

train_pois = 
  train %>% 
  rename(Confirmed = Daily.Confirmed) %>%
  select(Confirmed)
```

Initialize parameters:

``` r
N = 1341e6 # population size of India
data_initial = c(2059, 169, 58, 424, 9, 11)
pars_start = c(c(1,0.8,0.6,0.4,0.2), c(0.2,0.2,0.2,0.25,0.2))
phases = c(1,15,34,48,62)
```

## estimateR

If interest is in model estimation and not prediction, then use
`estimateR()`

``` r
?estimateR
```

``` r
cov19est = model_estimateR(data = train_multinom, init_pars = pars_start, 
                           data_init = data_initial, niter = 1e3, BurnIn = 1e2, 
                           model = "Multinomial", N = N, lambda = 1/(69.416 * 365), 
                           mu = 1/(69.416 * 365), period_start = phases, opt_num = 1, 
                           auto.initialize = TRUE, f = 0.15)
```

Inspect the results:

``` r
names(Result)
class(Result$mcmc_pars)
names(Result$plots)
```

Plot the results:

``` r
plot(cov19est, type = "trace")
plot(cov19est, type = "box")
```

## predictR

If interest is in model estimation and prediction, then use `predictR()`
on the `estimateR` result.

``` r
cov19pred = model_predictR(data = data_multinomial, init_pars = pars_start, 
                           data_init = data_initial, T_predict = 60, niter = 1e5, 
                           BurnIn = 1e5, data_test = data_test, model = "Multinomial", 
                           N = N, lambda = 1/(69.416 * 365), mu = 1/(69.416 * 365), 
                           period_start = phases, opt_num = 1, auto.initialize=TRUE, f=0.15)
```

Inspect the results:

``` r
names(Result)
class(Result$prediction)
class(Result$mcmc_pars)
names(Result$plots)
```

Plot the results:

``` r
plot(cov19pred, type = "trace")
plot(cov19pred, type = "box")
```

### Current Suggested Citation
