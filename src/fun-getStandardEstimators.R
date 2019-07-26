getStandardEstimators <- function(v, R, dt){
  N <- length(v) - 1
  gammaEst <- mean(R[-1]/v[-(N + 1)])
  betaEst  <-  ( mean(v[-1]/ v[-(N + 1)]) - (mean(v[-(N+1)]) * mean(1/v[-(N + 1)]))) /
    ( 1 - (mean(v[-(N+1)]) * mean(1/v[-(N + 1)])))
  alphaEst <- (1 - betaEst) * mean(v[-1])
  etaEst   <- sqrt((var(v[-1]/ v[-(N + 1)]) - alphaEst^2 * var(1/v[-(N + 1)]))/dt)
  
  list(gammaEst = gammaEst,
       betaEst = betaEst,
       alphaEst = alphaEst,
       etaEst = etaEst)
}
