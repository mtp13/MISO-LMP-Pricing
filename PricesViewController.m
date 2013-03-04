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

- (void)resetPrices
{
    self.onPeakLabel.text = [NSString stringWithFormat:@"On Peak = $%.2f",
                        [Prices averageOfOnPeakPrices:self.prices]];
    self.offPeakLabel.text = [NSString stringWithFormat:@"Off Peak = $%.2f",
                        [Prices averageOfOffPeakPrices:self.prices]];
    double profit = [Prices profitForPrices:self.prices];
    self.profitLabel.text = [NSString stringWithFormat:@"Profit = %@",
                             [self doubleAsCurrencyStyle:profit]];
    self.pricesTextView.text = [Prices pricesAsString:self.prices];
}

- (NSString *)doubleAsCurrencyStyle:(double)aDouble
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:aDouble]];
}

-(void)viewDidLoad {
    [self resetPrices];
}
@end
