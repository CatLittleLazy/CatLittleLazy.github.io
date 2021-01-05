/* according the cts calculate method
* MediaPerfUtils.java -> verifyAchievableFrameRates
* lowerRate / 2.2  <= realRate <= upperRate * 2.2
* upperRate / 4.84 <= realRate <= lowerRate * 4.84
*
* then we can get the expression like this:
* realRate / 4.84 <= lowerRate <= realRate * 2.2
* realRate / 2.2  <= upperRate <= realRate * 4.84
*/

#include <iostream>
#include <math.h>
using namespace std;
double FRAME_RATE = 2.2;
int SAFE_RANGE = 20;

void calculateRangeNormal(double relaRate){
	double minLowerRate = relaRate / pow(FRAME_RATE,2);
	double maxLowerRate = relaRate * FRAME_RATE;
	double minUpperRate = relaRate / FRAME_RATE;
	double maxUpperRate = relaRate * pow(FRAME_RATE,2); 
	cout << endl << "relaRate is " << relaRate << endl << endl;
	cout << minLowerRate << " <= lowerRate <= " << maxLowerRate << endl;
	cout << minUpperRate << " <= upperRate <= " << maxUpperRate << endl << endl;	
}

double* calculateRangeEasy(double rateMin,double rateMax){
	double minLowerRate = rateMax / pow(FRAME_RATE,2);
	double maxLowerRate = rateMin * FRAME_RATE;
	double minUpperRate = rateMax / FRAME_RATE;
	double maxUpperRate = rateMin * pow(FRAME_RATE,2); 
	cout << "the rate range should be " << endl << endl;
	cout << minLowerRate << " <= lowerRate <= " << maxLowerRate << endl;
	cout << minUpperRate << " <= upperRate <= " << maxUpperRate << endl << endl;
	double* result = new double[2];
	result[0] = maxLowerRate;
	result[1] = maxUpperRate;
	return result;
}

int main()
{
    cout << "MediaPerfUtils.java -> verifyAchievableFrameRates" << endl;
    cout << "Please input the min rate" << endl;
    double rateMin,rateMax;
    //rateMin = 79.05106698927507;
    //rateMax = 79.23165609398093;
	cin >> rateMin;
	cout << "Please input the max rate" << endl;
	cin >> rateMax;
	
	calculateRangeNormal(rateMin);
	calculateRangeNormal(rateMax);
	
	double* range = calculateRangeEasy(rateMin,rateMax);
	
	double rangeMin = min(range[0],range[1]);
	double rangeMax = max(range[0],range[1]);
	if (rangeMax - rangeMin < SAFE_RANGE || rangeMin < SAFE_RANGE){
		cout << ceil(rangeMin) << "-" << floor(rangeMax) << endl;
	} else{
		cout << ceil((rangeMin - SAFE_RANGE)) << "-" << floor((rangeMax - SAFE_RANGE)) << endl;	
	}
	
    return 0;
}