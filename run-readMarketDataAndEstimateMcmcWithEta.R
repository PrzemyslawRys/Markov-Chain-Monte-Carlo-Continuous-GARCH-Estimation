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
delta <- 0
kappa <- 10
nu    <- 0.1
eta   <- 4.0

# Choose "mins", "hours" or "days".
freq  <- "mins"

# Specify path where script saves results.
resultPath <- "pathToResults.Rds"
dataPath   <- "pathToData.Rds"

#  0. Generate the data                     
#______________________

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

# Reading data from Rds.
R <- readRDS(dataPath) %>%
  select(adjRate) %>%
  pull()

N <- length(R) - 1

#  1. MCMC estimation: assumptions
#_________________________________

numberOfLoops <- 20000

source("src/script-setPriorsAndInitialPoints.R")

#  2. MCMC estimation: core calculations.
#________________________________________

source("src/script-runMCMCwithEtawithoutV.R")
