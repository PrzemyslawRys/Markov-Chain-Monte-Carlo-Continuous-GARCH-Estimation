SPX_mid_rates <- readRDS("data/SPX_mid_rates.Rds")
source("src/fun-getOptionPriceFromMartingaleScenario.R")

strikes <- seq(from = 2000, to = 3000, by = 25)

pricesList <- list(readRDS("results/prices/price40.Rds"),
                   readRDS("results/prices/price80.Rds"),
                   readRDS("results/prices/price120.Rds"),
                   readRDS("results/prices/price160.Rds"),
                   readRDS("results/prices/price200.Rds"),
                   readRDS("results/prices/price240.Rds"),
                   readRDS("results/prices/price280.Rds"),
                   readRDS("results/prices/price320.Rds"),
                   readRDS("results/prices/price360.Rds"),
                   readRDS("results/prices/price400.Rds"),
                   readRDS("results/prices/priceRV405.Rds"),
                   readRDS("results/prices/priceRV2025.Rds"),
                   readRDS("results/prices/priceRV8505.Rds"))


optPrice   <- matrix(NA, length(strikes), length(pricesList))
optPriceSd <- optPrice

for(j in 1:length(pricesList)){
  result          <- getOptionPriceFromMartingaleScenario(strikes, pricesList[[j]], "C")
  optPrice[, j]   <- result$optionPrice
  optPriceSd[, j] <- result$optionPriceSd
}

plot(strikes, optPrice[, 1], type = "o", ylim = c(0, 600))
for(i in 2:10){
  lines(strikes, optPrice[, i], type = "o")
}

for(i in 11:length(pricesList)){
  lines(strikes, optPrice[, i], col = "red", type = "o")
}

abline(v = SPX_mid_rates$mid_price %>% last(), col = "blue")

lines(marketPrice$strike,
      0.5 * marketPrice$mid_price,
      col = "green",
      type = "o")

# conf. intervals 5%
optPriceCIUpper <- optPrice + optPriceSd * 1.96 / sqrt(length(pricesList[[1]]))
optPriceCILower <- optPrice - optPriceSd * 1.96 / sqrt(length(pricesList[[1]]))

saveRDS(optPrice, "results/optPrice.Rds")
saveRDS(optPriceCIUpper, "results/optPriceCIUpper.Rds")
saveRDS(optPriceCILower, "results/optPriceCILower.Rds")
saveRDS(optPriceSd, "results/optPriceSd.Rds")
