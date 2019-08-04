getStatsSingle <- function(series){
  series <- series %>% unlist() %>% na.omit() %>% as.numeric()
  
  c(series %>% min(),
    series %>% quantile(0.01) %>% as.numeric(),
    series %>% quantile(0.05) %>% as.numeric(),
    series %>% mean(),
    series %>% median(),
    series %>% quantile(0.95) %>% as.numeric(),
    series %>% quantile(0.99) %>% as.numeric(),
    series %>% max(),
    series %>% sd())
}
