//
//  LMPDayAhead.m
//  MISO LMP Pricing
//
//  Created by Mike Pullen on 10/24/12.
//  Copyright (c) 2012 Mike Pullen. All rights reserved.
//

#import "LMPDayAhead.h"

@implementation LMPDayAhead

+ (NSDictionary *)getHourlyPricesFromFile: (NSString *)aFile
{
    BOOL foundData = NO;
    NSArray *csvFields;
    NSMutableDictionary *hourlyPrices = [[NSMutableDictionary alloc] init];
        
    NSArray *lines = [aFile componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        csvFields = [self parseCSV:line];
        if (foundData) {
            if ([csvFields count] == 27) {
                NSString *k = [NSString stringWithFormat:@"%@_%@_%@",
                               csvFields[0], csvFields[1], csvFields[2]];
                NSRange theRange;
                theRange.location = 3;
                theRange.length = [csvFields count] - 3;
                NSArray *a = [csvFields subarrayWithRange:theRange];
                hourlyPrices[k] = a;
            }
        }
        else {
            if ([csvFields[0] isEqual:@"Node"]) {
                foundData = YES;
            }
        }
    }
    return hourlyPrices;
}

+ (NSArray *)parseCSV:(NSString *)s
{
    return [s componentsSeparatedByString:@","];
}

+ (float) getONPeakAverage:(NSArray *)prices
{
    float average = 0;
    for (int i = 6; i <= 21; i++){
        average += [prices[i] floatValue];
        
    }
    return average / 16.0;
}

+ (float) getOFFPeakAverage:(NSArray *)prices
{
    float average = 0;
    for (int i = 0; i <= 5; i++){
        average += [prices[i] floatValue];
    }
    for (int i = 22; i <= 23; i++){
        average += [prices[i] floatValue];
    }
    return average / 8.0;
}

+ (float) getProfit:(NSArray *)prices
{
    float dispatch = 22.08;
    float minDispatch = 20.05;
    float noLoadCost = 331;
    int minGen = 47;
    int maxGen = 167;
    float revenue = 0;
    float expense = 0;
    float profit = 0;

    for (int hour = 0; hour < 24; hour++) {
        float price = [prices[hour] floatValue];
        if (price < dispatch) {
            revenue += minGen * price;
            expense += minGen * minDispatch;
        } else {
            revenue += maxGen * price;
            expense += maxGen * dispatch;
        }
    }

    profit = revenue - (expense + 24 * noLoadCost);

    return profit;
}
@end