getSchemeParameters <- function(delta, kappa, nu, eta, dt){
  data.frame(gamma = delta * dt,
             alpha = kappa * nu * dt,
             beta = 1 - kappa * dt,
             eta = eta,
             dt = dt)
  }


