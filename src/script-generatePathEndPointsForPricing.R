library(dplyr)
library(Rcpp)
library(TTR)

sourceCpp("src/rcpp-getCOGARCHSettlementPrice.cpp")
source("src/fun-getEstimatorsFromResults.R")
source("src/fun-getModelParameters.R")
source("src/fun-getRealizedVarianceSeries.R")
source("src/fun-getStandardEstimators.R")

SPX_mid_rates   <- readRDS("data/SPX_mid_rates.Rds")

SPXMins_withEta  <- list(Eta40 = readRDS("results/SPXMins_withEta40.Rds"),
                         Eta80 =readRDS("results/SPXMins_withEta80.Rds"),
                         Eta120 = readRDS("results/SPXMins_withEta120.Rds"),
                         Eta160 = readRDS("results/SPXMins_withEta160.Rds"),
                         Eta200 = readRDS("results/SPXMins_withEta200.Rds"),
                         Eta240 = readRDS("results/SPXMins_withEta240.Rds"),
                         Eta280 = readRDS("results/SPXMins_withEta280.Rds"),
                         Eta320 = readRDS("results/SPXMins_withEta320.Rds"),
                         Eta360 = readRDS("results/SPXMins_withEta360.Rds"),
                         Eta400 = readRDS("results/SPXMins_withEta400.Rds"))

for(j in 1:10){
  currentResults <- SPXMins_withEta[[j]]
  currentParams  <- getEstimatorsFromResults(currentResults, 1 / (252 * 405))
  
  price <- numeric(1000000)
  
  for(i in 1:1000000){
    price[i] <- getCOGARCHSettlementPrice(alpha = currentParams[2, 1],
                                          beta = currentParams[3, 1],
                                          eta = currentParams[4, 1],
                                          r = (SPX_mid_rates$LIBOR3M %>% last()) / 100,
                                          dt = 1 / (252 * 405),
                                          vInitial = currentResults$vEstimate %>% last(),
                                          sInitial = SPX_mid_rates$mid_price %>% last(),
                                          numberOfSteps = 21 * 405,
                                          normalSample = rnorm(21 * 405 * 2))
    
  }
  
  cat(j, " done. \n")
  saveRDS(price, paste0("results/price", currentParams[4, 1] * 100, ".Rds"))
}

## for RV estimation

RVlength <- c(60, 405, 405 * 5, 405 * 21)

for(j in 1:length(RVlength)){
  currentVariance <- getRealizedVarianceSeries(SPX_mid_rates$adjRate,
                                               RVlength[j],
                                               1/ (405 * 252))
                                               
  currentParams  <- getStandardEstimators(v = currentVariance,
                                          R = SPX_mid_rates$adjRate,
                                          dt = 1/(405 * 252))
  
  price <- numeric(1000000)
  
  for(i in length(price):1000000){
    price[i] <- getCOGARCHSettlementPrice(alpha = currentParams[2, 1],
                                          beta = currentParams[3, 1],
                                          eta = currentParams[4, 1],
                                          r = (SPX_mid_rates$LIBOR3M %>% last()) / 100,
                                          dt = 1 / (252 * 405),
                                          vInitial = currentVariance %>% last(),
                                          sInitial = SPX_mid_rates$mid_price %>% last(),
                                          numberOfSteps = 21 * 405,
                                          normalSample = rnorm(21 * 405 * 2))
  }
  
  price <- price %>% na.omit()
  
  cat(j, " done. \n")
  saveRDS(price, paste0("results/priceRV", RVlength[j], ".Rds"))
}
