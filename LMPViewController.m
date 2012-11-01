//
//  LMPViewController.m
//  MISO LMP Pricing
//
//  Created by Mike Pullen on 10/24/12.
//  Copyright (c) 2012 Mike Pullen. All rights reserved.
//

#import "LMPViewController.h"
#include "LMPDayAheadFetcher.h"

@interface LMPViewController ()
{
    NSDate *LMPDate;
    NSDictionary *hourlyPrices;
}
@end

@implementation LMPViewController
@synthesize onPeakDisplay = _onPeakDisplay;
@synthesize offPeakDisplay = _offPeakDisplay;

- (IBAction)fetchLMPDailyFile:(id)sender
{
    LMPDate = [NSDate date];
    
    NSLog(@"%@", LMPDate);
    hourlyPrices = [LMPDayAheadFetcher fetchForDate:LMPDate];
    NSArray *a = [hourlyPrices objectForKey:@"EEI_Interface_LMP"];
    self.onPeakDisplay.text = [NSString stringWithFormat:@"On Peak = $%.2f",
                               [LMPDayAheadFetcher getONPeakAverage:a]];
    self.offPeakDisplay.text = [NSString stringWithFormat:@"Off Peak = $%.2f",
                               [LMPDayAheadFetcher getOFFPeakAverage:a]];
}

@end
