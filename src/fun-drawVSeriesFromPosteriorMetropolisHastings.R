drawVSeriesFromPosteriorMetropolisHastings <- function(currentV, R, alphaCurrent, betaCurrent, gammaCurrent, etaCurrent, dt, alpha_V, beta_V){
  vCurrent[1]     <-
    drawV0FromPosterior(v[1],
                        R[1],
                        v[2],
                        alphaCurrent,
                        betaCurrent,
                        gammaCurrent,
                        etaCurrent,
                        dt,
                        alpha_V,
                        beta_V)
  startTime <- Sys.time()
  for(j in 2:(N)){
    vCurrent[j]   <-
      drawViFromPosterior(vCurrent[j],
                          R[j],
                          vCurrent[j + 1],
                          vCurrent[j - 1],
                          alphaCurrent,
                          betaCurrent,
                          gammaCurrent,
                          etaCurrent,
                          dt)
  }
  endTime <- Sys.time()
  
  vCurrent[N + 1] <- drawVnFromPosterior(alphaCurrent, betaCurrent, etaCurrent, dt, vCurrent[N])
  
  vCurrent
}
