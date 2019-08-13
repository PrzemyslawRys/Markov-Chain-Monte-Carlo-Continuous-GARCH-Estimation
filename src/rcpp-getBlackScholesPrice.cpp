#include <Rcpp.h>
#include <cmath>
#include <math.h>
using namespace Rcpp;

double normalCDF(double x) // Phi(-∞, x) aka N(x)
{
  return std::erfc(-x/std::sqrt(2))/2;
}

/* the next row indicates that function will be exported to R */
  // [[Rcpp::export]]
  double getBlackScholesPrice(double underlyingPrice,
                              double strike,
                              double riskFreeRate,
                              double timeToMaturity,
                              double volatility,
                              char right,
                              double dividentYield = 0) {
    
    // Calculate current price.
    double d1 = (log(underlyingPrice / strike) +
      (riskFreeRate - dividentYield + pow(volatility, 2) / 2) * timeToMaturity) /
        (volatility * sqrt(timeToMaturity));
    double d2 = d1 - volatility * sqrt(timeToMaturity);
    
    double price;
    if(right == 'P'){
      price = - underlyingPrice * normalCDF(-d1) * exp(-dividentYield*timeToMaturity) + 
        strike*exp(-riskFreeRate*timeToMaturity) *
        normalCDF(-d2);
    } else if(right == 'C'){
      price = underlyingPrice * normalCDF(d1) * exp(-dividentYield*timeToMaturity) -
        strike*exp(-riskFreeRate*timeToMaturity) *
        normalCDF(d2);
    }
    
  return price;
}