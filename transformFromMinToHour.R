R <- aggregateLogarithmicRates(R, 60)
N <- length(R) - 1
v <- v[1:length(v) %% 60 == 0]

dt <- dt * 60
