generateVSeries <- function(N, initialValue, alpha, beta, eta, dt){
  v    <- numeric(N + 1)
  v[1] <- initialValue
  
  for(i in 2:(N + 1)){
    v[i] <- alpha + beta * v[i - 1] + eta * v[i - 1] * sqrt(dt) * rnorm(1)  
  }
  
  v
}
