R <- aggregateLogarithmicRates(R, 405)
N <- length(R) - 1
v <- v[1:length(v) %% 405 == 0]

dt <- dt * 405
