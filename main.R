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


# declare parameters
r     <- 0.02

delta <- 0
kappa <- 10
nu    <- 0.1
eta   <- 0.05
dt    <- 1/ (252 * 405)
N     <- 15 * (252 * 405)

resultPath <- "results/SPXMins_withEta40.Rds"

#_____________________________________
#  0. Generate the data                     
#_____________________________________

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
# mins 5 * 405 ; 405
# hours 21 * 7 ; 5 * 7
# days  63 : 21

vCurrent       <- getHistoricalVarianceSeries(R, 5 * 405, dt)
vCurrentMAD    <- numeric(numberOfLoops)
vCurrentMAD[1] <- mean(abs(vCurrent - v))
vEstimate      <- vCurrent

# a priori assumptions:
# - for gamma
mu_0       <- mean(R)
sigma2_0   <- 1
# - for (alpha, beta) direct approach
sigma2_A   <- runMean(R, 405) %>% na.omit() %>% var()
sigma2_B   <- runCor(vCurrent[-1],vCurrent[-(N+1)], 405) %>% na.omit() %>% var()
mu_A       <- 0
mu_B       <- cor(vCurrent[-1],vCurrent[-(N+1)])
# additional calculations for eta and V_0: fitting moments
eta2_mean  <- var(vCurrent[-1]/ vCurrent[-(N+1)]) / dt
eta2_var   <- (runVar(vCurrent[-1]/ vCurrent[-(N+1)], n = 405) / dt) %>% na.omit() %>% var()
v_mean     <- mean(vCurrent)
v_var      <- runMean(vCurrent, n = 405) %>% na.omit() %>% var()
# - for eta^2
etaAlpha_0 <- (eta2_mean^2 / eta2_var) - 2
etaBeta_0  <- eta2_mean * (etaAlpha_0  - 1)
# - for V_0
alpha_V    <- (v_mean^2 / v_var) - 2
beta_V     <- v_mean * (alpha_V  - 1)

# series for monitoring simulation stages, except v, which is too big
gammaSeries <- numeric(numberOfLoops)
alphaSeries <- numeric(numberOfLoops)
betaSeries  <- numeric(numberOfLoops)
etaSeries   <- numeric(numberOfLoops)
vEstimate   <- numeric(N + 1)

# starting points for MCMC hybrid method
gammaSeries[1] <- mu_0
alphaSeries[1] <- mu_A
betaSeries[1]  <- mu_B
etaSeries[1]   <- sqrt(eta2_mean)

# for with_eta
etaSeries[1]   <- eta
#_____________________________________
#  1. MCMC estimation: core
#_____________________________________

# main method
for(i in 2:numberOfLoops){
  gammaSeries[i] <-
    drawGammaFromPosterior(R,
                           vCurrent,
                           N,
                           dt,
                           mu_0,
                           sigma2_0)
  tempAlphaBeta   <-
    drawAlphaBetaFromPosterior(vCurrent,
                               etaSeries[i - 1],
                               dt,
                               mu_A,
                               mu_B,
                               sigma2_A,
                               sigma2_B)
  alphaSeries[i] <-
    tempAlphaBeta$alpha
  betaSeries[i]  <-
    tempAlphaBeta$beta
  
  # etaSeries[i]   <-
  #   drawEtaFromPosterior(N,
  #                        vCurrent,
  #                        alphaSeries[i],
  #                        betaSeries[i],
  #                        etaAlpha_0,
  #                        etaBeta_0)
  
  etaSeries[i] <- eta
  
   #Metropolis-Hastings for v
   
  vCurrent <-
    drawVSeriesFromPosteriorMetropolisHastingsRCPP(vCurrent,
                                               R,
                                               alphaSeries[i],
                                               betaSeries[i],
                                               gammaSeries[i],
                                               etaSeries[i],
                                               dt,
                                               alpha_V,
                                               beta_V)

  # vCurrent <- v

  # update vEstimate
  vEstimate <- vEstimate * (i - 1) / i + vCurrent / i
  # save MAD information about v
  #vCurrentMAD[i]  <- mean(abs(vCurrent - v))
  
  if(i %% 1000 == 0){
    cat(i, " done.", Sys.time() %>% as.character(), "\n")
    list(#v = v,
         R = R,
         alphaSeries = alphaSeries,
         betaSeries = betaSeries,
         gammaSeries = gammaSeries,
         etaSeries = etaSeries,
         vCurrent = vCurrent,
         vEstimate = vEstimate,
         vCurrentMAD = vCurrentMAD) %>%
    saveRDS(resultPath)
  }
}
