getStandardEstimators <- function(v, R, dt){
  N <- length(v) - 1
  gammaEst <- mean(R[-1]/v[-(N + 1)])
  betaEst  <-  ( mean(v[-1]/ v[-(N + 1)]) - (mean(v[-(N+1)]) * mean(1/v[-(N + 1)]))) /
    ( 1 - (mean(v[-(N+1)]) * mean(1/v[-(N + 1)])))
  alphaEst <- (1 - betaEst) * mean(v[-1])
  etaEst   <- sqrt((var(v[-1]/ v[-(N + 1)]) - alphaEst^2 * var(1/v[-(N + 1)]))/dt)
  
  modelEst <- getModelParameters(gammaEst, alphaEst, betaEst, etaEst, dt) %>% t()
  
  data.frame(gammaEst = gammaEst %>% as.numeric(),
       alphaEst = alphaEst %>% as.numeric(),
       betaEst = betaEst %>% as.numeric(),
       etaEst = etaEst %>% as.numeric(),
       deltaEst = modelEst[1,1] %>% as.numeric(),
       kappaEst = modelEst[1, 2] %>% as.numeric(),
       nuEst = modelEst[1, 3] %>% as.numeric()) %>% 
    t() %>%
    as.data.frame()
}
