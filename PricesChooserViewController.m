//
//  PricesChooserViewController.m
//  EEI
//
//  Created by Mike Pullen on 3/3/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import "PricesChooserViewController.h"
#import "MidwestISOFetcher.h"
#import "PricesViewController.h"

@interface PricesChooserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nodeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *pricesDatePicker;
@property (weak, nonatomic) NSString *node;
@property (weak, nonatomic) NSDate *date;
@property (weak, nonatomic) NSArray *prices;

@end

@implementation PricesChooserViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPrices"]) {
        if ([segue.destinationViewController isKindOfClass:[PricesViewController class]]) {
            PricesViewController *pvc = (PricesViewController *)segue.destinationViewController;
            pvc.prices.hourlyPrices = self.prices;
            pvc.title = [self dateAsString:self.date];
        }
    }
}

- (NSString *)dateAsString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    return [formatter stringFromDate:date];
}

- (NSDate *)date
{
    return [self.pricesDatePicker date];
}

- (NSString *)node
{
    return self.nodeLabel.text;
}

- (NSArray *)prices
{
    return [MidwestISOFetcher pricesForDate:self.date
                                       node:self.node];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:1];
    NSDate *tomorrow = [[NSCalendar currentCalendar]
                        dateByAddingComponents:componentsToAdd
                        toDate:[NSDate date]
                        options:0];
    self.pricesDatePicker.maximumDate = tomorrow;
}
@end