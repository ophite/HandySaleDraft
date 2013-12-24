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

@interface POSSettingsViewController : UITableViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textEmail;


@end
