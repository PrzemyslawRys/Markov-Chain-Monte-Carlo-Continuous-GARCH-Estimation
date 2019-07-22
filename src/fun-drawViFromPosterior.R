drawViFromPosterior <- function(currentVi, nextR, nextV, prevV, alpha, beta, gamma, eta, dt){
   proposition <- rnorm(1,
                        mean = mean(nextV, prevV),
                        sd = eta * sqrt(dt) * nextV)
   
  logProbabilityOfAcceptance <- 
    getLogDensityVi(proposition, nextR, nextV, prevV, gamma, alpha, beta, eta, dt) -
    getLogDensityVi(currentVi, nextR, nextV, prevV, gamma, alpha, beta, eta, dt)
  
  #if(logProbabilityOfAcceptance > log(runif(1))){
    result <- proposition
  #} else {
  #  result <- currentVi
  #}
  
  result
}