//
//  POSEditAttributeViewController.h
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

@interface POSEditAttributeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>


@property POSAttribute *attribute;
@property NSMutableArray *attributeValues;

@property (weak, nonatomic) IBOutlet UITableView *tableViewAttribute;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAttributeValue;


@end