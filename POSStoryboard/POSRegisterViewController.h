//
//  POSRegisterViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/6/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSDBHelper.h"


@interface POSRegisterViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textPassword2;


- (IBAction)onCreate:(id)sender;
- (BOOL)registerNewUser;


@end
