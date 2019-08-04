library(dplyr)
library(invgamma)
library(TTR)
#library(mvtnorm)
library(MASS)
library(Rcpp)
library(dygraphs)

sourceCpp("src/rcpp-drawViSeriesFromPosteriorMetropolisHastings.cpp")

funList <- paste0("src/",list.files("src"))
for(i in 1:length(funList)){
  if(substr(funList[i], 1, 7) == "src/fun")
    source(funList[i])
}

dt    <- 1/ (252 * 7)
N     <- 1 * (252 * 7) + 63 * 7
gamma <- 0.00005
alpha <- 0.0002
beta  <- 0.9988
oeta   <- 0.5

v <- generateVSeries(N, 0.15, alpha, beta, eta, dt)
R <- generateRSeries(gamma, v, dt)
price <- 50 * exp(cumsum(R))

plot(v, type = "l")
plot(R, type = "l")
plot(price, type = "l")

allSeries <- v %>% as_tibble() %>%
  mutate(R = R,
         price = price) %>%
  rename(v = value) %>%
  mutate(histVar1 = getHistoricalVarianceSeries(R, 7, dt),
         histVar5 = getHistoricalVarianceSeries(R, 5 * 7, dt),
         histVar21 = getHistoricalVarianceSeries(R, 21 * 7, dt),
         histVar63 = getHistoricalVarianceSeries(R, 63 * 7, dt),
         no = row_number()) %>%
  filter(no > 63 * 7)

allSeries %>% dplyr::select(no, v, histVar5, histVar21, histVar63) %>% dygraph()

params <- c(gamma, beta, alpha, eta)
names(params) <- c("gammaEst", "betaEst", "alphaEst", "etaEst")

estimators <-
  bind_rows(params,
            getStandardEstimators(allSeries$v, allSeries$R, dt) %>% unlist(),
            getStandardEstimators(allSeries$histVar5, allSeries$R, dt) %>% unlist(),
            getStandardEstimators(allSeries$histVar21, allSeries$R, dt) %>% unlist(),
            getStandardEstimators(allSeries$histVar63, allSeries$R, dt) %>% unlist()) %>%
  as.data.frame()

row.names(estimators) <- c("real", "est. v", "est. HVW", "est. HVM", "est. HVQ")

estimators$gammaAPE <- 100 * abs(estimators$gammaEst - gamma)/gamma
estimators$betaAPE  <- 100 * abs(estimators$betaEst - beta)/beta
estimators$alphaAPE <- 100 * abs(estimators$alphaEst - alpha)/alpha
estimators$etaAPE   <- 100 * abs(estimators$etaEst - eta)/eta

saveRDS(list(allSeries = allSeries,
             estimators = estimators),
        "standardEstimatorsTest.Rds")
