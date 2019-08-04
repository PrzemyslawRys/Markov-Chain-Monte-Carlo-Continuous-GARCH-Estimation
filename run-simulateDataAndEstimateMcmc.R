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
eta   <- 0.80

freq  <- "mins" # mins, hours or days

resultPath <- "results/test.Rds"

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

# generate simulated series
v <- generateVSeries(N, initialValue = nu, alpha, beta, eta, dt)
R <- generateRSeries(gamma, v, dt)

#_____________________________________
#  1. MCMC estimation: assumptions
#_____________________________________

# technical settings
numberOfLoops <- 20000

source("src/script-setPriorsAndInitialPoints.R")
vCurrentMAD    <- numeric(numberOfLoops)
vCurrentMAD[1] <- mean(abs(vCurrent - v))

#_____________________________________
#  1. MCMC estimation: core
#_____________________________________

source("src/script-runMCMC.R")
#or :
# source("src/script-runMCMCwithEta.R)
# source("src/script-runMCMwithEtaWithoutV.R)