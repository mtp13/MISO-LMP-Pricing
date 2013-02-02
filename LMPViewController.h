//
//  LMPViewController.h
//  MISO LMP Pricing
//
//  Created by Mike Pullen on 10/24/12.
//  Copyright (c) 2012 Mike Pullen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMPViewController : UIViewController
{
    NSURLConnection *connection;
    NSMutableData *receivedData;
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *onPeakLabel;
@property (weak, nonatomic) IBOutlet UILabel *offPeakLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *hourlyPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@end
