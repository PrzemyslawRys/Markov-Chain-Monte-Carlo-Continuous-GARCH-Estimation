aggregateLogarithmicRates <- function(logRates, conversionRate){
  logRates <- logRates %>%
    runSum(conversionRate)
  
  logRates[1:length(logRates) %% 60 == 0]
}
