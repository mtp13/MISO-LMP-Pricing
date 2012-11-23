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
@property (weak, nonatomic) IBOutlet UILabel *dateDisplay;
@property (weak, nonatomic) IBOutlet UILabel *onPeakDisplay;
@property (weak, nonatomic) IBOutlet UILabel *offPeakDisplay;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *hourlyPricesDisplay;
@end
