getHistoricalVarianceSeries <- function(R, windowLength, dt){
  temp <- (R %>%
    runVar(n = windowLength)) / dt
  
  # Filling starting NA observations with first non-NA value.
  temp[1:(windowLength - 1)] <- temp[windowLength]
  temp
}
