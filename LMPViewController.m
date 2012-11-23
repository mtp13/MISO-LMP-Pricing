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
@synthesize activityIndicator = _activityIndicator;

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

- (void)fetchFromMisoForDate:(NSDate *)aDate
{
    receivedData = [[NSMutableData alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *stringFromDate = [formatter stringFromDate:aDate];
    NSString *misoURL = [NSString stringWithFormat:
                         @"https://www.misoenergy.org/Library/Repository/Market Reports/%@_da_lmp.csv",
                         stringFromDate];
    NSURL *url = [NSURL URLWithString:[misoURL
                                       stringByAddingPercentEscapesUsingEncoding:
                                       NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSString *f = [[NSString alloc] initWithData:receivedData
                                        encoding:NSUTF8StringEncoding];
    NSDictionary *hourlyPrices = [LMPDayAhead getHourlyPricesFromFile:f];
    NSArray *a = [hourlyPrices objectForKey:@"EEI_Interface_LMP"];
    if (a) {
        self.onPeakDisplay.text = [NSString stringWithFormat:@"On Peak = $%.2f",
                                   [LMPDayAhead getONPeakAverage:a]];
        self.offPeakDisplay.text = [NSString stringWithFormat:@"Off Peak = $%.2f",
                                    [LMPDayAhead getOFFPeakAverage:a]];
        NSString *hourlyPriceDisplayString = [NSString string];
        float price;
        for (int he = 1; he <25; he++) {
            price = [a[he-1] floatValue];
            hourlyPriceDisplayString = [hourlyPriceDisplayString
                                        stringByAppendingFormat:
                                        @"HE %i       %.2f", he, price];
            if (he != 24) hourlyPriceDisplayString =
                [hourlyPriceDisplayString stringByAppendingFormat:@"\n"];
        }
        self.hourlyPricesDisplay.text = hourlyPriceDisplayString;
    }
    if (!a) self.offPeakDisplay.text = @"No prices available yet.";
    [self.activityIndicator stopAnimating];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    connection = nil;
    receivedData = nil;
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil];
    [av show];
}

- (void)updateDisplayForDate:(NSDate *)aDate
{
    [self.activityIndicator startAnimating];
    [self fetchFromMisoForDate:aDate];
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
    self.onPeakDisplay.text = @"";
    self.offPeakDisplay.text = @"";
    self.hourlyPricesDisplay.text = @"";
}

@end
