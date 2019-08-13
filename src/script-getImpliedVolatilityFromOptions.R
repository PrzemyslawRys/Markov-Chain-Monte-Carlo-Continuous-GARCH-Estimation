library(dplyr)
library(Rcpp)
sourceCpp("src/rcpp-getImpliedVolatility.cpp")

optPrice        <- readRDS("results/optPrice.Rds")
optPriceCILower <- readRDS("results/optPriceCILower.Rds")
optPriceCIUpper <- readRDS("results/optPriceCIUpper.Rds")
SPX             <- readRDS("data/SPX_mid_rates.Rds")

strikes <- seq(from = 2000, to = 3000, by = 25)

impliedVol <- optPrice
for(i in 1:nrow(optPrice)){
  for(j in 1:ncol(optPrice)){
    impliedVol[i, j] <- getImpliedVolatility(SPX$mid_price %>% last(),
                                             strikes[i],
                                             SPX$r %>% last(),
                                             21 / 252,
                                             optPrice[i, j], 
                                             'C')
  }
}

impliedVolCIUpper <- optPrice
for(i in 1:nrow(optPrice)){
  for(j in 1:ncol(optPrice)){
    impliedVolCIUpper[i, j] <- getImpliedVolatility(SPX$mid_price %>% last(),
                                             strikes[i],
                                             SPX$r %>% last(),
                                             21 / 252,
                                             optPriceCIUpper[i, j], 
                                             'C')
  }
}

impliedVolCILower <- optPrice
for(i in 1:nrow(optPrice)){
  for(j in 1:ncol(optPrice)){
    impliedVolCILower[i, j] <- getImpliedVolatility(SPX$mid_price %>% last(),
                                                    strikes[i],
                                                    SPX$r %>% last(),
                                                    21 / 252,
                                                    optPriceCILower[i, j], 
                                                    'C')
  }
}

saveRDS(impliedVol, "results/impliedVol.Rds")
saveRDS(impliedVolCIUpper, "results/impliedVolCIUpper.Rds")
saveRDS(impliedVolCILower, "results/impliedVolCILower.Rds")
