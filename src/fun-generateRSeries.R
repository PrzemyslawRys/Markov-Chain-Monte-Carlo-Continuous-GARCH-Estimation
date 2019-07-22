generateRSeries <- function(gamma, v, dt){
  N <- length(v)
  R <- numeric(N)
  
  for(i in 2:(N)){
    R[i] <- gamma * v[i - 1] + sqrt(v[i - 1] * dt) * rnorm(1)
  }
  
  # first observation does not exist, because we don't have volatility
  # fill it with mean just for codes simplification
  R[1] <- mean(R[-1])
  
  R
}
