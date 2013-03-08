//
//  PricesTVC.m
//  EEI
//
//  Created by Mike Pullen on 3/6/13.
//  Copyright (c) 2013 Mike Pullen. All rights reserved.
//

#import "PricesTVC.h"

@interface PricesTVC ()
@end

@implementation PricesTVC

- (void)setPrices:(Prices *)prices
{
    _prices = prices;
    [self.tableView reloadData];
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.prices.hourlyPrices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HourlyPricesDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Hour %i",indexPath.row + 1];
    cell.detailTextLabel.text = [self priceForRow:indexPath];
    return cell;
}

- (NSString *)priceForRow:(NSIndexPath *)indexPath
{
    double p = [self.prices.hourlyPrices[indexPath.row] doubleValue];
    return [NSString stringWithFormat:@"$%.2f", p];
}

@end
