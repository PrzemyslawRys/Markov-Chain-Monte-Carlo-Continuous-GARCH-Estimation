drawEtaFromPosterior <- function(N, v, alpha, beta, etaAlpha_0, etaBeta_0){
  rinvgamma(1,
            N/2 + 1 + etaAlpha_0,
            sum((v[-1] - alpha - beta * v[-(N + 1)])^2 / (2 * v[-(N + 1)]^2 * dt)) + etaBeta_0) %>%
    sqrt()
}
