getLogDensityDiffV0 <- function(proposition, current, R1, V1, alpha, beta, gamma, eta, dt, alpha_V, beta_V){
  -log((proposition/current)^(3 / 2 + alpha_V)) -((1 / (2 * dt * proposition))*((1 / eta^2 * proposition) * (V1 - alpha - beta * proposition)^2 +
                                              (R1 - gamma * proposition)^2) - beta_V/proposition) -
    (-(1 / (2 * dt * current))*((1 / eta^2 * current) * (V1 - alpha - beta * current)^2 +
                                                                         (R1 - gamma * current)^2) - beta_V/current)
}
