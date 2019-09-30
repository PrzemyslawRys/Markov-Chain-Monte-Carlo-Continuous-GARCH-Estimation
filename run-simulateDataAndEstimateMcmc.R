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

# Declare parameters for simulations.                     
r     <- 0.02
delta <- -0.2
kappa <- 0.5
nu    <- 0.4
eta   <- 2.0

# Choose "mins", "hours" or "days".
freq  <- "mins"

# Specify path where script saves results.
resultPath <- "pathToResults.Rds"


# 0. Generating the data.  
# ____________________

# Assumptions: 405 mins per day, 7 hours per day, 21 days per month, 252 days per year.
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

# Calculating new parameters.
schemeParameters <- getSchemeParameters(delta, kappa, nu, eta, dt)

gamma <- schemeParameters$gamma
alpha <- schemeParameters$alpha
beta  <- schemeParameters$beta

# Simulating input data.
v <- generateVSeries(N, initialValue = nu, alpha, beta, eta, dt)
R <- generateRSeries(gamma, v, dt)


# 1. MCMC estimation: assumptions.
#________________________________

numberOfLoops <- 20000

source("src/script-setPriorsAndInitialPoints.R")
vCurrentMAD    <- numeric(numberOfLoops)
vCurrentMAD[1] <- mean(abs(vCurrent - v))

#  2. MCMC estimation: core calculations.
#__________________________

# Select "src/script-runMCMC.R" for standard estimation.
# Or select "src/script-runMCMCWithEta.R" for estimation with fixed eta parameter.
source("src/script-runMCMC.R")
