getComparisonStats <- function(series, series2){
  series <- series %>%
    left_join(series2, by = "Date")
  
  names(series) <- c("Datetime", "series", "series2")
  
  series <- series %>%
    filter(!is.na(series) & !is.na(series2)) %>%
    mutate(diff = series - series2,
           absDiff = abs(diff),
           relDiff = (series - series2) / series2,
           absRelDiff = abs(relDiff))
  
  diffStats       <- getStatsSingle(series$diff)
  absDiffStats    <- getStatsSingle(series$absDiff)
  relDiffStats    <- getStatsSingle(series$relDiff)
  absRelDiffStats <- getStatsSingle(series$absRelDiff)
  
  data.frame(diffStats       = getStatsSingle(series$diff),
             absDiffStats    = getStatsSingle(series$absDiff),
             relDiffStats    = getStatsSingle(series$relDiff),
             absRelDiffStats = getStatsSingle(series$absRelDiff),
             row.names = c("min", "q1%", "q5%", "mean", "median", "q95%", "q99%", "max", "sd"))
}
