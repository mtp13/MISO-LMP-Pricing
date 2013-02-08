//
//  LMPDayAhead.h
//  MISO LMP Pricing
//
//  Created by Mike Pullen on 10/24/12.
//  Copyright (c) 2012 Mike Pullen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMPDayAhead : NSObject

+ (NSDictionary *)getHourlyPricesFromFile: (NSString *)aFile;
+ (double) getONPeakAverage:(NSArray *)prices;
+ (double) getOFFPeakAverage:(NSArray *)prices;
+ (double) getProfit:(NSArray *)prices;
@end
