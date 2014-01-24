//
//  POSBasketPaymentViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/23/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSHelper.h"
#import "POSObjectsHelper.h"
#import "POSOrder.h"
#import "POSSettingsGUIHelper.h"

@interface POSBasketPaymentViewController : UIViewController

@property float paydAmount;
@property float unpaydAmount;

@property (weak, nonatomic) IBOutlet UIButton *buttonPay;
@property (weak, nonatomic) IBOutlet UITextField *textFieldIUnpaidAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelPaid;
@property (weak, nonatomic) IBOutlet UILabel *labelPaidAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrency;

- (IBAction)onPay:(id)sender;


@end