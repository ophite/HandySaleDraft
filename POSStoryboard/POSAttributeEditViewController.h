//
//  POSAttributeEditViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/26/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSAttribute.h"
#import "POSDBWrapper.h"
#import "POSObjectsHelper.h"
#import "POSEditAttributeStaticCell.h"
#import "POSEditAttributeDynamicCell.h"
#import "POSKBKeyboardHandlerDelegate.h"
#import "POSKBKeyboardHandler.h"
#import "UIView+POSFindFirstResponder.h"
#import "POSHelper.h"

@interface POSAttributeEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, POSKBKeyboardHandlerDelegate> {
    
    POSKBKeyboardHandler *keyboard;
@private
    id __deletedCell;
    
}

@property POSAttribute *attribute;
@property NSMutableArray *attributeValues;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAttributeValue;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddNewVariant;


- (IBAction)onAddNewAttrValue:(id)sender;


@end
