//
//  POSRemindPasswordViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/3/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSHelper.h"
#import "POSObjectsHelper.h"
#import "POSDBWrapper.h"
#import "POSDataSet.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface POSRemindPasswordViewController : UIViewController <UITextFieldDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textEmail;


- (IBAction)onResetPassword:(id)sender;


@end
