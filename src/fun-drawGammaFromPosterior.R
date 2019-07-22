drawGammaFromPosterior <- function(R, v, N, dt, mu_0, sigma2_0){
  rnorm(1,
        mean = (sum(R[-1]) + dt * mu_0 / sigma2_0) / (sum(v[- (N + 1)]) + dt / sigma2_0),
        sd = sqrt(dt / (sum(v[ - (N + 1)]) + dt / sigma2_0)))
}
