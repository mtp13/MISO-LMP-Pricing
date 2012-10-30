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

- (IBAction)fetchLMPDailyFile:(id)sender
{
    LMPDate = [NSDate date];
    
    NSLog(@"%@", LMPDate);
    hourlyPrices = [LMPDayAheadFetcher fetchForDate:LMPDate];
    NSArray *a = [hourlyPrices objectForKey:@"EEI_Interface_LMP"];
    NSLog(@"ON Peak = %f", [LMPDayAheadFetcher getONPeakAverage:a]);
    NSLog(@"OFF Peak = %f", [LMPDayAheadFetcher getOFFPeakAverage:a]);
}



@end
