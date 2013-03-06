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
                             [self.prices onPeakAverage]];
    self.offPeakLabel.text = [NSString stringWithFormat:@"Off Peak = $%.2f",
                              [self.prices offPeakAverage]];
    double profit = [self.prices profit];
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
    NSString *displayString = [[NSString alloc] init];
    double price;
    for (int i = 0; i <24; i++) {
        price = [prices.hourlyPrices[i] doubleValue];
        displayString = [displayString stringByAppendingFormat:@"HE %i       %.2f", i, price];
        if (i != 23) displayString = [displayString stringByAppendingString:@"\n"];
    }
    return displayString;
}

-(void)viewDidLoad {
    [self resetPrices];
}
@end
