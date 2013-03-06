//
//  MidwestISOFetcher.m
//  EEI
//
//  Created by Mike Pullen on 3/3/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import "MidwestISOFetcher.h"

@implementation MidwestISOFetcher

+ (Prices *)pricesForDate:(NSDate *)date node:(NSString *)node
{
    Prices *prices = [[Prices alloc] init];
    NSDictionary *dictionary = [self executeMidwestISOFetch:date];
    prices.hourlyPrices = [dictionary objectForKey:node];
    return prices;
}

+ (NSDictionary *)executeMidwestISOFetch:(NSDate *)date
{
    NSURL *url = [self misoURLFromDate:date];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];

    // dictionary of prices using nodes as key
    NSDictionary *dictionary = [self dictionaryFromData:data];
    return dictionary;
}

+ (NSURL *)misoURLFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *misoString = [NSString stringWithFormat:
                            @"https://www.misoenergy.org/Library/Repository/Market Reports/%@_da_lmp.csv",
                            [formatter stringFromDate:date]];
    return [NSURL URLWithString:[misoString
                                       stringByAddingPercentEscapesUsingEncoding:
                                       NSUTF8StringEncoding]];
}

+ (NSDictionary *)dictionaryFromData:(NSData *)data
{
    NSString *stringData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];

    BOOL foundData = NO;
    NSArray *csvFields;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    NSArray *lines = [stringData componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        csvFields = [self parseCSV:line];
        if (foundData) {
            if ([csvFields count] == 27) {
                NSString *k = [NSString stringWithFormat:@"%@_%@",
                               csvFields[0], csvFields[2]];
                NSRange theRange;
                theRange.location = 3;
                theRange.length = [csvFields count] - 3;
                NSArray *a = [csvFields subarrayWithRange:theRange];
                dictionary[k] = a;
            }
        }
        else {
            if ([csvFields[0] isEqual:@"Node"]) {
                foundData = YES;
            }
        }
    }
    return dictionary;
}

+ (NSArray *)parseCSV:(NSString *)s
{
    return [s componentsSeparatedByString:@","];
}

@end
