/* load Rcpp module */
  
  #include <Rcpp.h>
  #include <cmath>
  using namespace Rcpp;

/* the next row indicates that function will be exported to R */
  // [[Rcpp::export]]
NumericVector drawViSeriesFromPosteriorMetropolisHastingsRCPP(NumericVector vCurrent, 
                              NumericVector R,
                              double alphaCurrent,
                              double betaCurrent,
                              double gammaCurrent,
                              double etaCurrent,
                              double dt,
                              double alpha_V,
                              double beta_v,
                              NumericVector normalSample,
                              NumericVector uniformSample) {
  
  /* declatarions */
  int N = vCurrent.size();
  double proposition;
  double logProbabilityOfAcceptance;
   
  for(int j = 1; j < N - 1; j++){
    
    proposition = 0.5*(vCurrent[j+1]+vCurrent[j-1])+normalSample[j - 1]*etaCurrent*pow(dt, 0.5)*vCurrent[j+1];
    
    logProbabilityOfAcceptance = 
      log(fabs(proposition-alphaCurrent)/pow(proposition, 3/2)) +
      - (1/(2 * dt)) *
      ((1 / (pow(etaCurrent,2) * pow(proposition,2))) * pow(vCurrent[j + 1] - alphaCurrent - betaCurrent * proposition,2) + 
      (1/proposition) * pow(R[j+1] - gammaCurrent * proposition,2) +
      (pow(proposition - alphaCurrent,2) / pow(etaCurrent,2)) * pow((1 / vCurrent[j - 1]) - betaCurrent / (proposition - alphaCurrent),2)) -
      // next density below
      (log(fabs(vCurrent[j]-alphaCurrent)/pow(vCurrent[j], 3/2)) +
      - (1/(2 * dt)) *
      ((1 / (pow(etaCurrent,2) * pow(vCurrent[j],2))) * pow(vCurrent[j + 1] - alphaCurrent - betaCurrent * vCurrent[j],2) + 
      (1/vCurrent[j]) * pow(R[j+1] - gammaCurrent * vCurrent[j],2) +
      (pow(vCurrent[j] - alphaCurrent,2) / pow(etaCurrent,2)) * pow((1 / vCurrent[j - 1]) - betaCurrent / (vCurrent[j] - alphaCurrent),2)));
    
    if(logProbabilityOfAcceptance > log(uniformSample[j - 1])){
      vCurrent[j] = proposition;
    }
  }
    
    /* return the vector of pnls */
      return vCurrent;
}