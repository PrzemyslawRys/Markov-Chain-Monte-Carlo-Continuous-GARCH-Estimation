library(dplyr)
library(Rcpp)
sourceCpp("src/rcpp-getBlackScholesPrice.cpp")
SPX             <- readRDS("data/SPX_mid_rates.Rds")

prices <- seq(from = 2000, to = 3000, by = 25) %>%
  as.data.frame()

prices$price <- NA
names(prices) <- c("strike", "price")


volatility <- sqrt(252 * 405) * (SPX$rate %>% sd())

for(i in 1:nrow(prices)){
  prices$price[i] <- getBlackScholesPrice(SPX$mid_price %>% last(),
                                       prices$strike[i],
                                       SPX$r %>% last(),
                                       21 / 252,
                                       volatility,
                                       "C")
}

saveRDS(prices, "results/blackScholesPrices.Rds")
