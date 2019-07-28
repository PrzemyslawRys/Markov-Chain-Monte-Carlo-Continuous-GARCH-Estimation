aggregateLogarithmicRates <- function(logRates, conversionRate){
  logRates <- logRates %>%
    runSum(conversionRate)
  
  logRates[1:length(logRates) %% conversionRate == 0]
}
