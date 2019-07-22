drawVnFromPosterior <- function(alpha, beta, eta, dt, vn_1){
  rnorm(1,
        mean = alpha + beta * vn_1,
        sd = eta * vn_1 * dt)
}