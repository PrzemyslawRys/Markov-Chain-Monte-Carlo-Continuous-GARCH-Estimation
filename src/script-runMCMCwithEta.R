etaSeries[1] <- eta

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
  
  etaSeries[i]   <- eta
  
  # Metropolis-Hastings for v.
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
  
  # Updating vEstimate.
  vEstimate <- vEstimate * (i - 1) / i + vCurrent / i
  
  # Saving MAD statistic for v.
  vCurrentMAD[i]  <- mean(abs(vCurrent - v))
  
  if(i %% 1000 == 0){
    cat(i, " done.", Sys.time() %>% as.character(), "\n")
    list(v = v,
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
