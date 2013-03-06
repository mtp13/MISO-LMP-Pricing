//
//  PricesViewController.m
//  EEI
//
//  Created by Mike Pullen on 3/2/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import "PricesViewController.h"
#import "Prices.h"

@interface PricesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *onPeakLabel;
@property (weak, nonatomic) IBOutlet UILabel *offPeakLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UITextView *pricesTextView;

@end

@implementation PricesViewController

- (Prices *)prices
{
    if (!_prices) _prices = [[Prices alloc] init];
    return _prices;
}

- (void)resetPrices
{
    self.onPeakLabel.text = [NSString stringWithFormat:@"On Peak = $%.2f",
                        [self.prices averageOfOnPeakPrices]];
    self.offPeakLabel.text = [NSString stringWithFormat:@"Off Peak = $%.2f",
                        [self.prices averageOfOffPeakPrices]];
    double profit = [self.prices profitForPrices];
    self.profitLabel.text = [NSString stringWithFormat:@"Profit = %@",
                             [self doubleAsCurrencyStyle:profit]];
    self.pricesTextView.text = [self pricesAsString:self.prices];
}

- (NSString *)doubleAsCurrencyStyle:(double)aDouble
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:aDouble]];
}

- (NSString *)pricesAsString:(Prices *)prices
{
    NSString *displayString = [NSString string];
    double price;
    for (int he = 1; he <25; he++) {
        price = [prices.hourlyPrices[he-1] doubleValue];
        displayString = [displayString
                                    stringByAppendingFormat:
                                    @"HE %i       %.2f", he, price];
        if (he != 24) displayString =
            [displayString stringByAppendingString:@"\n"];
    }
    return displayString;
}

-(void)viewDidLoad {
    [self resetPrices];
}
@end
