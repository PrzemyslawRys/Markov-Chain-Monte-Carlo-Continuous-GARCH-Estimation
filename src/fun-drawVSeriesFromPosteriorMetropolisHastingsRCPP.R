drawVSeriesFromPosteriorMetropolisHastingsRCPP <- function(currentV, R, alphaCurrent, betaCurrent, gammaCurrent, etaCurrent, dt, alpha_V, beta_V){
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
  vCurrent <- drawViSeriesFromPosteriorMetropolisHastingsRCPP(vCurrent,
                                                              R,
                                                              alphaSeries[i],
                                                              betaSeries[i],
                                                              gammaSeries[i],
                                                              etaSeries[i],
                                                              dt,
                                                              alpha_V,
                                                              beta_V,
                                                              rnorm(N),
                                                              runif(N))
  
  vCurrent[N + 1] <- drawVnFromPosterior(alphaCurrent, betaCurrent, etaCurrent, dt, vCurrent[N])
  
  vCurrent
}
