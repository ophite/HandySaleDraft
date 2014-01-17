//
//  POSLoginViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/6/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSTest.h"
#import "POSObjectsHelper.h"
#import "POSKBKeyboardHandler.h"
#import "POSKBKeyboardHandlerDelegate.h"
#import "UIView+POSFindFirstResponder.h"

@interface POSLoginViewController: UIViewController<UITextFieldDelegate, POSKBKeyboardHandlerDelegate> {
    
    POSKBKeyboardHandler *keyboard;

@private
    BOOL __rememberChecked;

}
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UIView *viewWithControls;
@property (weak, nonatomic) IBOutlet UIView *viewForColorExample;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonRememberMe;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;


- (BOOL)isUserHasCorrectPassword;
- (IBAction)onRememberMe:(id)sender;


@end
