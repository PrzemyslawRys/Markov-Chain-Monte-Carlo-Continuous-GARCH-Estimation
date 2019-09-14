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
double getImpliedVolatility(double underlyingPrice,
                            double strike,
                            double riskFreeRate,
                            double timeToMaturity,
                            double price,
                            char right,
                            double dividentYield = 0,
                            double pricePrecision  = 0.00001,
                            double impliedVolatilityPrecision = 0.00001,
                            double stepSizeMultiplier = 0.0001,
                            int maxIteration = 1000000) {

  // bool finishCondition = FALSE;
  double impliedVolatility = 0.2;
  double currentPrice;
  double stepSize;
  double d1;
  double d2;
  double previousImpliedVolatility;
  double beforePreviousImpliedVolatility;
  
  // check if implied volatility exists
  if((right == 'P' && price < strike - underlyingPrice) ||
     (right == 'C' && price < underlyingPrice - strike)){
    return -1;
  }
  
  int i = 0;
  while (TRUE) {
    // Calculate current price.
    d1 = (log(underlyingPrice / strike) +
      (riskFreeRate - dividentYield + pow(impliedVolatility, 2) / 2) * timeToMaturity) /
        (impliedVolatility * sqrt(timeToMaturity));
    d2 = d1 - impliedVolatility * sqrt(timeToMaturity);
    
    if(right == 'P'){
      currentPrice = - underlyingPrice * normalCDF(-d1) * exp(-dividentYield*timeToMaturity) + 
        strike*exp(-riskFreeRate*timeToMaturity) *
        normalCDF(-d2);
    } else if(right == 'C'){
      currentPrice = underlyingPrice * normalCDF(d1) * exp(-dividentYield*timeToMaturity) -
        strike*exp(-riskFreeRate*timeToMaturity) *
        normalCDF(d2);
    } else {
      return -3;
    }
    
    // For stop rule.
    beforePreviousImpliedVolatility = previousImpliedVolatility;
    previousImpliedVolatility = impliedVolatility;
    
    // if currentPrice close enough target price then end
    if(currentPrice / price > 1 - pricePrecision &&
       currentPrice / price < 1 + pricePrecision) {
      return impliedVolatility;
    } else{
      // Make step.
      stepSize = (1/ (2 * M_PI)) * price * sqrt(timeToMaturity) *
        exp (-pow(d1, 2) / 2);
      
      stepSize *= stepSizeMultiplier;
      
      if(stepSize < impliedVolatilityPrecision){
        stepSize = impliedVolatilityPrecision;
      }
      
      if(currentPrice < price){
        impliedVolatility += stepSize;
      } else if(currentPrice > price){
        impliedVolatility -= stepSize;
      }
      
      // Stop condition for implied volatility step.
      if(stepSize == impliedVolatilityPrecision &
         beforePreviousImpliedVolatility == impliedVolatility){
        {
          return 0.5 * (impliedVolatility + beforePreviousImpliedVolatility);
        }
      }
    }
    
    if(i > maxIteration){
      return -2;
    }
    
    i++;
  }
  
  return impliedVolatility;
  
}