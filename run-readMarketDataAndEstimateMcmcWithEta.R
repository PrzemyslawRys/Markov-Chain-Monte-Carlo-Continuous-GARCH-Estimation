library(dplyr)
library(invgamma)
library(TTR)
library(mvtnorm)
library(Rcpp)

# Make sure your compiler enable C++ 11 standard.
# Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
sourceCpp("src/rcpp-drawViSeriesFromPosteriorMetropolisHastings.cpp")

funList <- paste0("src/",list.files("src"))
for(i in 1:length(funList)){
  if(substr(funList[i], 1, 7) == "src/fun")
  source(funList[i])
}

#______________________________________
#   Declare parameters for simulations                     
#______________________________________

r     <- 0.02
delta <- 0
kappa <- 10
nu    <- 0.1
eta   <- 4.0

freq  <- "mins" # mins, hours or days

resultPath <- "results/SPXMins_withEta400.Rds"

#_____________________________________
#  0. Generate the data                     
#_____________________________________

# assumptions: 405 mins per day, 7 hours per day, 21 days per month, 252 days per year
if(freq == "mins"){
  dt    <- 1 / (252 * 405)
  N     <- 15 * (252 * 405)
}

if(freq == "hours"){
  dt    <- 1 / (252 * 7)
  N     <- 15 * (252 * 7)
}

if(freq == "days"){
  dt    <- 1 / (252 * 405)
  N     <- 15 * (252 * 405)
}

# calculate new parameters
schemeParameters <- getSchemeParameters(delta, kappa, nu, eta, dt)

gamma <- schemeParameters$gamma
alpha <- schemeParameters$alpha
beta  <- schemeParameters$beta

# read data
R <- readRDS("data/SPX_mid_rates.Rds") %>%
  select(adjRate) %>%
  pull()

N <- length(R) - 1

#_____________________________________
#  1. MCMC estimation: assumptions
#_____________________________________

# technical settings
numberOfLoops <- 20000

source("src/script-setPriorsAndInitialPoints.R")

#_____________________________________
#  1. MCMC estimation: core
#_____________________________________

source("src/script-runMCMCwithEtawithoutV.R")
