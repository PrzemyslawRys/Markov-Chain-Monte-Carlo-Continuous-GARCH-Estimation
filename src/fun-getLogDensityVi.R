getLogDensityVi <- function(x, nextR, nextV, prevV, gamma, alpha, beta, eta, dt){
  log(abs(x-alpha)/x^(3/2)) +
    - (1/(2 * dt)) *
          ((1 / (eta^2 * x^2)) * (nextV - alpha - beta * x)^2 + 
             (1/x) * (nextR - gamma * x)^2 +
             ((x - alpha)^2 / eta^2) * ((1 / prevV) - beta / (x - alpha)) ^ 2)
}
