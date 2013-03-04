//
//  Prices.h
//  EEI
//
//  Created by Mike Pullen on 3/2/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prices : NSObject

+ (double)averageOfOnPeakPrices:(NSArray *)prices;
+ (double)averageOfOffPeakPrices:(NSArray *)prices;
+ (double)profitForPrices:(NSArray *)prices;
+ (NSString *)pricesAsString:(NSArray *)prices;

@end
