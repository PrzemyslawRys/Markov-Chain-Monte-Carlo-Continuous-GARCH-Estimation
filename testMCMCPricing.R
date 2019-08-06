price <- numeric(100000)
for(i in 1:100000){
  price[i] <- getCOGARCHSettlementPrice(0,1,0.8,0,0.02,1/ (252 * 405), 0.15, 100, 21 * 405, rnorm(21 * 405 * 2))
}

mPayoff    <- numeric(21)
sdPayoff   <- numeric(21)
lowerBound <- numeric(21)
upperBound <- numeric(21)

K <- 90:110

for(i in 1:21){
  payoff   <- exp(-0.02 * 21/(252 * 405)) * (price - K[i])  
  payoff   <- ifelse(payoff < 0, 0 , payoff)
  
  mPayoff[i]  <- mean(payoff)
  sdPayoff[i] <- sd(payoff)
  
  lowerBound[i] <- mPayoff[i] - 1.96 * sdPayoff[i] / sqrt(100000)
  upperBound[i] <- mPayoff[i] + 1.96 * sdPayoff[i] / sqrt(100000)
}

plot(mPayoff, ylim = c(0,15), type = "p")
lines(lowerBound, col = "red")
lines(upperBound, col = "red")
