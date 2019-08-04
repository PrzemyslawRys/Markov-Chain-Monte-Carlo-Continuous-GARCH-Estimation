getModelParameters <- function(gamma, alpha, beta, eta, dt){
  data.frame(delta = gamma / dt,
             kappa = (1 - beta) / dt,
             nu = alpha / (1 - beta),
             eta = eta,
             dt = dt) %>% t()
}
