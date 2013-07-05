//
//  Prices.m
//  EEI
//
//  Created by Mike Pullen on 3/2/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import "Prices.h"

@implementation Prices

- (double)onPeakAverage
{
    double average = 0.0;
    for (int i = 6; i <= 21; i++){
        average += [self.hourlyPrices[i] doubleValue];
    }
    return average / 16.0;
}

- (double)offPeakAverage
{
    double average = 0.0;
    for (int i = 0; i <= 5; i++){
        average += [self.hourlyPrices[i] doubleValue];
    }
    for (int i = 22; i <= 23; i++){
        average += [self.hourlyPrices[i] doubleValue];
    }
    return average / 8.0;
}

#define P1 19.29
#define P2 22.10
#define Q1 1
#define Q2 167
#define NL 332
#define minGen 47
#define maxGen Q2

- (double)averageCostForDispatchLevel:(double)dispatchLevel
{
    double P = dispatchLevel - 1;
    return (P * P1 + 0.5 * P * P * (P2 - P1) / (Q2 - Q1) + P1) / dispatchLevel + NL / dispatchLevel;
}

- (double)profit
{
    double incrementalCost = P2;
    double revenue = 0.0;
    double expense = 0.0;
    double profit = 0.0;

    double averageMinCost = [self averageCostForDispatchLevel:minGen];
    double averageMaxCost = [self averageCostForDispatchLevel:maxGen];

    for (int hour = 0; hour < 24; hour++) {
        double price = [self.hourlyPrices[hour] doubleValue];
        if (price < incrementalCost) {
            revenue += minGen * price;
            expense += minGen * averageMinCost;
        } else {
            revenue += maxGen * price;
            expense += maxGen * averageMaxCost;
        }
    }
    profit = revenue - expense;
    return profit;
}

@end
