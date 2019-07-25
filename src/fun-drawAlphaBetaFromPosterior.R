drawAlphaBetaFromPosterior <- function(v, eta, dt, mu_A, mu_B, sigma2_A, sigma2_B){
  X <- (1/(2 * eta^2 * dt))*(sum(v[-(N+1)]^(-2))+ eta^2 * dt / sigma2_A)
  Y <- (1/(2 * eta^2 * dt))*(N + eta^2 * dt / sigma2_B)
  Z <- -(1/(eta^2 * dt)) * sum(v[-(N+1)]^(-1))

  mu_alpha <- (sum(v[-1] * v[-(N + 1)]^(-2) + (mu_A * eta^2 * dt / sigma2_A)) -
                 sum(v[-(N+1)]^(-1)) * (sum(v[-1] * v[-(N+1)]^(-1)) +
                                          (mu_B * eta^2 * dt / sigma2_B)) / N) /
    (sum(v[-(N + 1)]^(-2)) + (eta^2 * dt / sigma2_A) - sum(v[-(N+1)]^(-1)) * sum(v[-(N+1)]^(-1)) / N)
  
  mu_beta <- (sum(v[-1] * v[-(N + 1)]^(-1)) + mu_B * eta^2 * dt / sigma2_B - mu_alpha * sum(v[-1]^(-1))) /
    (N + eta^2 * dt / sigma2_B) 
  
  sigma2_alpha <- 1 / (2 * X - sqrt(X/Y) * Z)
  sigma2_beta  <- sigma2_alpha * X / Y
  xi           <- 1 - 1 / (2 * sigma2_alpha * X)
  
  mvrnorm(1, mu = c(mu_alpha, mu_beta),
          Sigma = matrix(c(sigma2_alpha, sqrt(sigma2_alpha * sigma2_beta) * xi,
                           sqrt(sigma2_alpha * sigma2_beta) * xi, sigma2_beta),
                         2,2)) %>%
    as.data.frame() %>%
    t() %>%
    as.data.frame() %>%
    rename(alpha = V1, beta = V2)
}
