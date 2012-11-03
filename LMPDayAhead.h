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
+ (float) getONPeakAverage:(NSArray *)prices;
+ (float) getOFFPeakAverage:(NSArray *)prices;

@end
