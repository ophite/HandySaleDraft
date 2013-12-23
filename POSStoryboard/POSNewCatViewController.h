//
//  POSNewCatViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/13/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "POSDBWrapper.h"
#import "POSCategory.h"
#import "POSObjectsHelper.h"


@interface POSNewCatViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textImageName;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;


- (IBAction)onCreate:(id)sender;
- (BOOL)createdNewCategory;


@end
