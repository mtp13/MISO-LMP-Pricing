//
//  Prices.h
//  EEI
//
//  Created by Mike Pullen on 3/2/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prices : NSObject

@property (nonatomic, strong) NSArray *hourlyPrices; //this was weak and didn't work ????
- (double)onPeakAverage;
- (double)offPeakAverage;
- (double)profit;
@end
