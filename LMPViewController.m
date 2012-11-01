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
@end

@implementation LMPViewController

@synthesize dateDisplay = _dateDisplay;
@synthesize onPeakDisplay = _onPeakDisplay;
@synthesize offPeakDisplay = _offPeakDisplay;

- (NSDate *)getYesterdaysDate
{
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:-1];

    NSDate *yesterday = [[NSCalendar currentCalendar]
                         dateByAddingComponents:componentsToSubtract
                         toDate:[NSDate date]
                         options:0];
    return yesterday;
}

- (NSDate *)getTomorrowsDate
{
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:1];

    NSDate *tomorrow = [[NSCalendar currentCalendar]
                         dateByAddingComponents:componentsToAdd
                         toDate:[NSDate date]
                         options:0];
    return tomorrow;
}

-(void)updateDisplay:(NSDate *)aDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:aDate];
    self.dateDisplay.text = formattedDateString;

    self.onPeakDisplay.text = @"On Peak = $00.00";
    self.offPeakDisplay.text = @"Off Peak = $00.00";
}

- (IBAction)changeLMPDate:(id)sender
{
    NSDate *LMPDate;


    int i = [sender selectedSegmentIndex];
    if (i == 0) {
        LMPDate = [self getYesterdaysDate];
        [self updateDisplay:LMPDate];
        [self fetchLMPDailyFile:LMPDate];
    }
    if (i == 1) {
        LMPDate = [NSDate date];
        [self updateDisplay:LMPDate];
        [self fetchLMPDailyFile:LMPDate];
    }
    if (i == 2) {
        LMPDate = [self getTomorrowsDate];
        [self updateDisplay:LMPDate];
        [self fetchLMPDailyFile:LMPDate];
    }

}

- (void)fetchLMPDailyFile:(NSDate *)aDate
{
    NSDate *LMPDate = aDate;
    NSDictionary *hourlyPrices = [LMPDayAheadFetcher fetchForDate:LMPDate];
    NSArray *a = [hourlyPrices objectForKey:@"EEI_Interface_LMP"];
    self.onPeakDisplay.text = [NSString stringWithFormat:@"On Peak = $%.2f",
                               [LMPDayAheadFetcher getONPeakAverage:a]];
    self.offPeakDisplay.text = [NSString stringWithFormat:@"Off Peak = $%.2f",
                               [LMPDayAheadFetcher getOFFPeakAverage:a]];
}

@end
