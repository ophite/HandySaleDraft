//
//  POSNewGoodViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/16/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSDBWrapper.h"
#import "POSObjectsHelper.h"

@interface POSNewGoodViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textImageName;

- (IBAction)onCreate:(id)sender;
- (BOOL)createdNewGood;

@end
