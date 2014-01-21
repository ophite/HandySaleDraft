//
//  POSSelectCategoryViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/18/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "POSItem.h"
#import "POSObjectsHelper.h"
#import "POSCategory.h"
#import "POSEditGoodViewController.h"

@interface POSSelectCategoryViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>


@property POSItem *item;
@property POSCategory *category;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;


- (IBAction)onSelect:(id)sender;


@end
