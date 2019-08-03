library(readr)
library(dplyr)
library(xts)

dt <- 1 / (252 * 405)

SPX <- readRDS("data/SPX_min_2004-01-02-2019-06-17.Rds") %>%
  select(timestamp, mid_price) %>%
  arrange(timestamp) %>%
  mutate(date = timestamp %>% as.Date()) %>%
  left_join(read_csv("data/ukousd3m_d.csv") %>%
              select(date = Data,
                     LIBOR3M = Zamkniecie),
            on = "date") %>%
  select(-date) %>%
  arrange(timestamp) %>%
  mutate(r = 4 * log(1 + LIBOR3M / 400),
         r = na.locf(r),
         rate = c(0, diff(log(mid_price))),
         adjRate = rate * exp(-r * dt)) %>%
  filter(timestamp < "2019-01-01" %>% as.POSIXct()) 

saveRDS(SPX, "data/SPX_mid_rates.Rds")
