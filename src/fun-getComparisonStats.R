getComparisonStats <- function(series, series2){
  series <- series %>%
    as_tibble() %>%
    rename(series = value) %>%
    mutate(series2 = series2) %>%
    filter(!is.na(series) & !is.na(series2)) %>%
    mutate(diff = series - series2,
           absDiff = abs(diff),
           relDiff = (series - series2) / series2,
           absRelDiff = abs(relDiff))
  
  diffStats       <- getStatsSingle(series$diff)
  absDiffStats    <- getStatsSingle(series$absDiff)
  relDiffStats    <- getStatsSingle(series$relDiff)
  absRelDiffStats <- getStatsSingle(series$absRelDiff)
  
  data.frame(#diffStats       = getStatsSingle(series$diff) %>% as.numeric(),
             absDiffStats    = 100 * (getStatsSingle(series$absDiff) %>% as.numeric()),
             #relDiffStats    = getStatsSingle(series$relDiff) %>% as.numeric(),
             absRelDiffStats = 100 * (getStatsSingle(series$absRelDiff) %>% as.numeric()),
             row.names = c("min", "q1%", "q5%", "mean", "median", "q95%", "q99%", "max", "sd"))
}
