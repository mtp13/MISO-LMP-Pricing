//
//  Prices.m
//  EEI
//
//  Created by Mike Pullen on 3/2/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import "Prices.h"

@implementation Prices

+ (double)averageOfOnPeakPrices:(NSArray *)prices
{
    double average = 0;
    for (int i = 6; i <= 21; i++){
        average += [prices[i] doubleValue];
    }
    return average / 16.0;
}

+ (double)averageOfOffPeakPrices:(NSArray *)prices
{
    double average = 0;
    for (int i = 0; i <= 5; i++){
        average += [prices[i] doubleValue];
    }
    for (int i = 22; i <= 23; i++){
        average += [prices[i] doubleValue];
    }
    return average / 8.0;
}

#define P1 19.17
#define P2 21.97
#define Q1 1
#define Q2 167
#define NL 329
#define minGen 47
#define maxGen Q2

+ (double)averageCostForDispatchLevel:(double)dispatch
{
    double P = dispatch - 1;
    return (P * P1 + 0.5 * P * P * (P2 - P1) / (Q2 - Q1) + P1) / dispatch + NL / dispatch;
}

+ (double)profitForPrices:(NSArray *)prices
{
    double incrementalCost = P2;
    double revenue = 0;
    double expense = 0;
    double profit = 0;

    double averageMinCost = [self averageCostForDispatchLevel:minGen];
    double averageMaxCost = [self averageCostForDispatchLevel:maxGen];

    for (int hour = 0; hour < 24; hour++) {
        double price = [prices[hour] doubleValue];
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

+(NSString *)pricesAsString:(NSArray *)prices
{
    NSString *hourlyPriceDisplayString = [NSString string];
    double price;
    for (int he = 1; he <25; he++) {
        price = [prices[he-1] doubleValue];
        hourlyPriceDisplayString = [hourlyPriceDisplayString
                                    stringByAppendingFormat:
                                    @"HE %i       %.2f", he, price];
        if (he != 24) hourlyPriceDisplayString =
            [hourlyPriceDisplayString stringByAppendingString:@"\n"];
    }
    return hourlyPriceDisplayString;
}

@end
