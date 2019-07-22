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
delta <- 1
kappa <- 2
nu    <- 0.15
eta   <- 0.3
dt    <- 1/ (252 * 7 * 60)
N     <- 15 * (252 * 7 * 60)

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
numberOfLoops <- 3000

vCurrent       <- getHistoricalVarianceSeries(R, 5 * 7 * 60, dt)
vCurrentMAD    <- numeric(numberOfLoops)
vCurrentMAD[1] <- mean(abs(vCurrent - v))
vEstimate      <- vCurrent

# a priori assumptions:
# - for gamma
mu_0       <- mean(R)
sigma2_0   <- 1
# - for (alpha, beta) direct approach
sigma2_A   <- runMean(R, 60 * 7) %>% na.omit() %>% var()
sigma2_B   <- runCor(vCurrent[-1],vCurrent[-(N+1)], 60 * 7) %>% na.omit() %>% var()
mu_A       <- 0
mu_B       <- cor(vCurrent[-1],vCurrent[-(N+1)])
# additional calculations for eta and V_0: fitting moments
eta2_mean  <- var(vCurrent[-1]/ vCurrent[-(N+1)]) / dt
eta2_var   <- (runVar(vCurrent[-1]/ vCurrent[-(N+1)], n = 60 * 7) / dt) %>% na.omit() %>% var()
v_mean     <- mean(vCurrent)
v_var      <- runMean(vCurrent, n = 60 * 7) %>% na.omit() %>% var()
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
  
  etaSeries[i]   <-
    drawEtaFromPosterior(N,
                         vCurrent,
                         alphaSeries[i],
                         betaSeries[i],
                         etaAlpha_0,
                         etaBeta_0)
  
   #Metropolis-Hastings for v
  # vCurrent <-
  #    drawVSeriesFromPosteriorMetropolisHastings(vCurrent,
  #                                               R,
  #                                               alphaSeries[i],
  #                                               betaSeries[i],
  #                                               gammaSeries[i],
  #                                               etaSeries[i],
  #                                               dt,
  #                                               alpha_V,
  #                                               beta_V)
  # 
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
  
  #vSeries <- v

  # update vEstimate
  vEstimate <- vEstimate * (i - 1) / i + vCurrent
  # save MAD information about v
  vCurrentMAD[i]  <- mean(abs(vCurrent - v))
  
  cat(i, " : 3000 \n")
}

#_____________________________________
#  3. MCMC estimation: results
#_____________________________________

# estimate parameters by mean from Markov chain
gammaEstimate <- mean(gammaSeries)
alphaEstimate <- mean(alphaSeries)
betaEstimate  <- mean(betaSeries)
etaEstimate   <- mean(etaSeries)

#_____________________________________
#  4. MCMC estimation: verification
#_____________________________________

# plots and stats

# check
getModelParameters(gamma, alpha, beta, eta, dt)
getModelParameters(gammaEstimate, alphaEstimate, betaEstimate, etaEstimate, dt)

# ______________________________________

# estimate gamma

gamma_est <- (sum(R[-1]) + dt * mu_0 / sigma2_0) / (sum(v) + dt / sigma2_0)

cat("delta = \n", delta, "\n",
    "delta = \n", gamma_est / dt, "\n",
    "mu_0 / dt = \n", mu_0 / dt, "\n",
    "sigma2_0 = \n", sigma2_0)

# eta ok, gamma ok,
# w GB alpha jest super wrażliwa na zmiany bety
gammaSeries %>% plot()
((gammaSeries %>% cumsum()) / (1:numberOfLoops)) %>% plot(type = "l")
abline(h = gamma, col = "red")

alphaSeries %>% plot(type = "l")
alphaSeries[-(1:100)] %>% plot(type = "l")
((alphaSeries[-(1:100)] %>% cumsum()) / (1:2900)) %>% plot(type = "l")
abline(h = alpha, col = "red")

betaSeries %>% plot(type = "l")
betaSeries[-(1:100)] %>% plot(type = "l")
((betaSeries[-(1:100)] %>% cumsum()) / (1:2900)) %>% plot(type = "l")
abline(h = beta, col = "red")


etaSeries %>% plot(type = "l")
etaSeries[-(1:100)] %>% plot(type = "l")
((etaSeries %>% cumsum()) / (1:3000)) %>% plot(type = "l")
((etaSeries[-(1:100)] %>% cumsum()) / (1:2900)) %>% plot(type = "l")

vCurrentMAD %>% plot(type = "l")

# check
gamma
gammaEstimate
gammaSeries[1]

alpha
alphaEstimate
alphaSeries[1]

beta
betaEstimate
betaSeries[1]
