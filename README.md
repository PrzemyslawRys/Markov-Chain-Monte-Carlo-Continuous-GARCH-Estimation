# Continuous GARCH Bayesian Estimation by Markov Chain Monte Carlo

The project contains all code required to reproduce results of my research on bayesian estimation of volatility and structural parameters of continuous GARCH model with Markov Chain Monte Carlo (MCMC) methods. The structure of repository, e.g. extracting functionalities into different functions allow user to easily calibrate continuous GARCH model and estimate volatility process for any time series. Additionally functions simulating artificial data from considered models are included.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Please check prerequisities below and make sure to install all packages and libraries before running the code.

- *dplyr* package for data manipulation,
- *invgamma* package for sampling from inverse gamma distribution,
- *TTR* package for functions to analyze data over moving window of periods,
- *Rcpp* to accelerate complex calculations using C++,
- C++ compiler enabling C++ 11 standard.

### Input data structure

Script *run-simulateDataAndEstimateMcmc.R* is designed to test method efficiency on simulated data, thus it does not need any data to run, At the beginning new dataset is generated in accordance with user-specified parameters and then full estimation procedure is executed.

Script *run-readMarketDataAndEstimateMcmcWithEta.R* is suited to estimate structural parameters and volatility from market data. In consequence it requires providing path to .Rds file with proper tibble object. Object should have 

### Example of usage

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo



## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc

