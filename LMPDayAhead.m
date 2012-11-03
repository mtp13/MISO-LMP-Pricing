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
    for (NSString *l in lines) {
        csvFields = [self parseCSV:l];
        if (foundData) {
            if ([csvFields count] == 27) {
                NSString *k = [NSString stringWithFormat:@"%@_%@_%@",
                               [csvFields objectAtIndex:0],
                               [csvFields objectAtIndex:1],
                               [csvFields objectAtIndex:2]];
                NSRange theRange;
                theRange.location = 3;
                theRange.length = [csvFields count] - 3;
                NSArray *a = [csvFields subarrayWithRange:theRange];
                [hourlyPrices setObject:a forKey:k];
            }
        }
        else {
            if ([[csvFields objectAtIndex:0] isEqual:@"Node"]) {
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
        average += [[prices objectAtIndex:i] floatValue];
        
    }
    return average / 16.0;
}

+ (float) getOFFPeakAverage:(NSArray *)prices
{
    float average = 0;
    for (int i = 0; i <= 5; i++){
        average += [[prices objectAtIndex:i] floatValue];
    }
    for (int i = 22; i <= 23; i++){
        average += [[prices objectAtIndex:i] floatValue];
    }
    return average / 8.0;
}

@end
