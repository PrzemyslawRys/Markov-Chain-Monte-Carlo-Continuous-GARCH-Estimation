# Set priors and initial points.

if(freq == "mins"){
  shortWindow <- 405
  longWindow  <- 5 * 405
}

if(freq == "hours"){
  shortWindow <- 35
  longWindow  <- 147
}

if(freq == "days"){
  shortWindow <- 21
  longWindow  <- 63
}

vCurrent       <- getHistoricalVarianceSeries(R, longWindow, dt)
vEstimate      <- vCurrent

# a priori assumptions:
# - for gamma
mu_0       <- mean(R)
sigma2_0   <- 1
# - for (alpha, beta) direct approach
sigma2_A   <- runMean(R, shortWindow) %>% na.omit() %>% var()
sigma2_B   <- runCor(vCurrent[-1],vCurrent[-(N+1)], shortWindow) %>% na.omit() %>% var()
mu_A       <- 0
mu_B       <- cor(vCurrent[-1],vCurrent[-(N+1)])
# additional calculations for eta and V_0: fitting moments
eta2_mean  <- var(vCurrent[-1]/ vCurrent[-(N+1)]) / dt
eta2_var   <- (runVar(vCurrent[-1]/ vCurrent[-(N+1)], n = shortWindow) / dt) %>% na.omit() %>% var()
v_mean     <- mean(vCurrent)
v_var      <- runMean(vCurrent, n = shortWindow) %>% na.omit() %>% var()
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