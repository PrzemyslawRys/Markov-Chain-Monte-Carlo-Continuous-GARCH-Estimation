getOptionPriceFromMartingaleScenario <- function(strikes, prices, type){
  prices <- prices %>% na.omit()
  
  optionPrice   <- numeric(length(strikes))
  optionPriceSd <- numeric(length(strikes))
  
  for(i in 1:length(strikes)){
    if(type == "C"){
      payoff     <- (prices - strikes[i])
    } else if (type == "P"){
      payoff     <- (strikes[i] - prices)
    }
    
    payoff <- ifelse(payoff < 0, 0, payoff)
    
    optionPrice[i]   <- mean(payoff)
    optionPriceSd[i] <- sd(payoff) / sqrt(length(prices))
  }
  
  list(optionPrice = optionPrice,
       optionPriceSd = optionPriceSd)
}

