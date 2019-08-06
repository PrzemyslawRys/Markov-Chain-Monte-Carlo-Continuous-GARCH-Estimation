/* load Rcpp module */
  
  #include <Rcpp.h>
  #include <cmath>
  using namespace Rcpp;
 
/* the next row indicates that function will be exported to R */
  // [[Rcpp::export]]
  double getCOGARCHSettlementPrice(double alpha,
                                          double beta,
                                          double eta,
                                          double gamma,
                                          double r,
                                          double dt,
                                          double vInitial,
                                          double sInitial,
                                          int numberOfSteps,
                                          NumericVector normalSample) {
  
    double currentPrice = sInitial;
    double currentRate = 0;
    double currentVariance = vInitial;
    
    for(int i = 1; i < numberOfSteps; i++){
      currentRate = gamma * currentVariance + sqrt(currentVariance * dt) * normalSample[i];
      currentPrice = currentPrice * exp(currentRate + r * dt);
      
      currentVariance = alpha + beta * currentVariance + eta * currentVariance * sqrt(dt) * normalSample[i + numberOfSteps];  
    }
    
    return currentPrice;
}
  