//
//  MidwestISOFetcher.h
//  EEI
//
//  Created by Mike Pullen on 3/3/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidwestISOFetcher : NSObject

+ (NSArray *)pricesForDate:(NSDate *)date node:(NSString *)node;

@end
