# Continuous GARCH Bayesian Estimation by Markov Chain Monte Carlo

The project contains all code required to reproduce the results of my research on Bayesian estimation of volatility and structural parameters of continuous GARCH model with Markov Chain Monte Carlo (MCMC) methods. The structure of the repository, e.g. extracting functionalities into different functions allows a user to easily calibrate the continuous GARCH model and estimate the volatility process for any time series. Additionally, functions simulating artificial data from considered models are included.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Please check prerequisites below and make sure to install all packages and libraries before running the code.

- *dplyr* package for data manipulation,
- *invgamma* package for sampling from an inverse gamma distribution,
- *TTR* package for functions to analyze data over moving the window of periods,
- *Rcpp* to accelerate complex calculations using C++,
- C++ compiler enabling C++ 11 standard.

### Input data structure

Script *run-simulateDataAndEstimateMcmc.R* is designed to test method efficiency on simulated data, thus it does not need any data to run, At the beginning, new dataset is generated in accordance with user-specified parameters and then full estimation procedure is executed.

Script *run-readMarketDataAndEstimateMcmcWithEta.R* is suited to estimate structural parameters and volatility from market data. In consequence, it requires providing the path to .Rds file with proper tibble object. The object should have a column named adjRate containing adjusted rates of return, what mean rates decreased by a risk-free rate for specified frequency. Please remember to use a risk-free factor for that frequency, not an annualized one. 

## Authors

* **Przemysław Ryś** - [see Github](https://github.com/PrzemyslawRys), [see Linkedin](https://www.linkedin.com/in/przemyslawrys/)

## License

This code is free software you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 2 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

