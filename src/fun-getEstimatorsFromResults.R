getEstimatorsFromResults <- function(results, dt){
  estimators <- data.frame(gammaEstimate = mean(results$gammaSeries),
                           alphaEstimate = mean(results$alphaSeries),
                           betaEstimate = mean(results$betaSeries),
                           etaEstimate = mean(results$etaSeries)) %>% t() %>%
    as.data.frame()
  
  modelEst <- getModelParameters(estimators[1,1] %>% as.numeric(),
                                 estimators[2,1] %>% as.numeric(),
                                 estimators[3,1] %>% as.numeric(),
                                 estimators[4,1] %>% as.numeric(),
                                 dt) %>%
    as.data.frame()
  
  modelEst <- modelEst[-(4:5), ] %>%
    as.data.frame()
  
  row.names(modelEst) <- c("delta", "kappa", "nu")
  
  names(estimators) <- "estimator"
  names(modelEst)   <- "estimator"
  
  rbind(estimators,
            modelEst)
}
