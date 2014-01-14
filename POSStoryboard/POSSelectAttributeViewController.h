//
//  POSSelectAttributeViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/8/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSAttribute.h"
#import "POSObjectsHelper.h"
#import "POSHelper.h"


@interface POSSelectAttributeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>


@property POSCategory *category;
@property POSAttribute *oldAttribute;
@property POSCategoryAttribute *categoryAttribute;
@property int attributeIndex;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;


- (IBAction)onSelect:(id)sender;


@end
