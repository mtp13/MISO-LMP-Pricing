//
//  MidwestISOFetcher.m
//  EEI
//
//  Created by Mike Pullen on 3/3/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import "MidwestISOFetcher.h"

@implementation MidwestISOFetcher

+(NSArray *)pricesForDate:(NSDate *)date node:(NSString *)node
{
    NSDictionary *dictionary = [self executeMidwestISOFetch:date];
    return [dictionary objectForKey:node];
}

+(NSURL *)misoURLFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    NSString *misoURL = [NSString stringWithFormat:
                         @"https://www.misoenergy.org/Library/Repository/Market Reports/%@_da_lmp.csv",
                         stringFromDate];
    NSURL *url = [NSURL URLWithString:[misoURL
                                       stringByAddingPercentEscapesUsingEncoding:
                                       NSUTF8StringEncoding]];
    return url;
}

+ (NSDictionary *)executeMidwestISOFetch:(NSDate *)date
{
    NSURL *url = [self misoURLFromDate:date];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];

    // dictionary of prices using nodes as key
    NSDictionary *results = [self dictionaryFromData:data];
    return results;
}

+(NSDictionary *)dictionaryFromData:(NSData *)data
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
                NSString *k = [NSString stringWithFormat:@"%@_%@_%@",
                               csvFields[0], csvFields[1], csvFields[2]];
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
