//
//  LMPViewController.m
//  MISO LMP Pricing
//
//  Created by Mike Pullen on 10/24/12.
//  Copyright (c) 2012 Mike Pullen. All rights reserved.
//

#import "LMPViewController.h"
#include "LMPDayAhead.h"

@interface LMPViewController ()
@end

@implementation LMPViewController

@synthesize dateDisplay = _dateDisplay;
@synthesize onPeakDisplay = _onPeakDisplay;
@synthesize offPeakDisplay = _offPeakDisplay;

- (IBAction)changeLMPDate:(id)sender
{
    NSDate *LMPDate;

    int i = [sender selectedSegmentIndex];
    if (i == 0) {
        LMPDate = [self getYesterdaysDate];
        [self resetDisplay:LMPDate];
        [self updateDisplayForDate:LMPDate];
    }
    if (i == 1) {
        LMPDate = [NSDate date];
        [self resetDisplay:LMPDate];
        [self updateDisplayForDate:LMPDate];
    }
    if (i == 2) {
        LMPDate = [self getTomorrowsDate];
        [self resetDisplay:LMPDate];
        [self updateDisplayForDate:LMPDate];
    }

}

- (NSString *)getFileFromMisoForDate:(NSDate *)aDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *stringFromDate = [formatter stringFromDate:aDate];
    NSString *misoURL = [NSString stringWithFormat:
                         @"https://www.misoenergy.org/Library/Repository/Market Reports/%@_da_lmp.csv",
                         stringFromDate];
    NSURL *url = [NSURL URLWithString:[misoURL
                                    stringByAddingPercentEscapesUsingEncoding:
                                    NSUTF8StringEncoding]];
    NSError *error;
    NSString *lmpString = [NSString stringWithContentsOfURL:url
                                                   encoding:NSUTF8StringEncoding
                                                      error:&(error)];
    return lmpString;
}

- (void)updateDisplayForDate:(NSDate *)aDate
{
    NSString *f = [self getFileFromMisoForDate:aDate];
    NSDictionary *hourlyPrices = [LMPDayAhead getHourlyPricesFromFile:f];
    NSArray *a = [hourlyPrices objectForKey:@"EEI_Interface_LMP"];
    self.onPeakDisplay.text = [NSString stringWithFormat:@"On Peak = $%.2f",
                               [LMPDayAhead getONPeakAverage:a]];
    self.offPeakDisplay.text = [NSString stringWithFormat:@"Off Peak = $%.2f",
                               [LMPDayAhead getOFFPeakAverage:a]];
}

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

-(void)resetDisplay:(NSDate *)aDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:aDate];
    self.dateDisplay.text = formattedDateString;

    self.onPeakDisplay.text = @"On Peak = $00.00";
    self.offPeakDisplay.text = @"Off Peak = $00.00";
}

@end
