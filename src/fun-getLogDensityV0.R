getLogDensityV0 <- function(x, R1, V1, alpha, beta, gamma, eta, dt, alpha_V, beta_V){
  -log(x^(3 / 2 + alpha_V)) -(1 / (2 * dt * x))*((1 / eta^2 * x) * (V1 - alpha - beta * x)^2 +
                                              (R1 - gamma * x)^2) - beta_V/x
}
