getRealizedVarianceSeries <- function(R, windowLength, dt){
  temp <- ((R^2) %>%
    runMean(n = windowLength)) / dt
  
  # fill starting NA observations with first non-NA value
  temp[1:(windowLength - 1)] <- temp[windowLength]
  temp
}
