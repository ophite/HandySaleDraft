//
//  POSSettingsViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSObjectsHelper.h"
#import "POSHelper.h"
#import "POSSetting.h"
#import "POSSelectSettingsViewController.h"


@interface POSSettingsViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonMoney;
@property (weak, nonatomic) IBOutlet UIButton *buttonLanguage;
@property (weak, nonatomic) IBOutlet UISwitch *switchWIFI;
@property (weak, nonatomic) IBOutlet UISwitch *switchVAT;


@end
