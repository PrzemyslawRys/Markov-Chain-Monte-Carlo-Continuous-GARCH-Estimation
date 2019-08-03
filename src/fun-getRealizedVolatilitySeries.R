getRealizedVolatilitySeries <- function(R, windowLength, dt){
  getRealizedVarianceSeries(R, windowLength, dt) %>%
    sqrt()
}
