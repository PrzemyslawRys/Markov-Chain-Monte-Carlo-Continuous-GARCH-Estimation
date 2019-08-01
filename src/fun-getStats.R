getStats <- function(indices, colNames, treshold = NA){
  
  stats <- matrix(NA, 9, 3) %>%
    as.data.frame(row.names = c("min", "1pct", "5pct", "mean", "median", "95pct", "99pct", "max", "SD"))
  
  names(stats) <- colNames
  
  # stats from rates
  stats[, 1] <- getStatsSingle(indices[, 5])
  stats[, 2] <- getStatsSingle(indices[, 6])
  stats[, 3] <- getStatsSingle(indices[, 7])
  
  # annualize sd
  stats[9, ] <- stats[9, ] * sqrt(252/5)
  
  stats
}
