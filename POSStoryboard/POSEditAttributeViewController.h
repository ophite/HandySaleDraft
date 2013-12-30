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

@interface POSEditAttributeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property POSAttribute *attribute;
@property NSMutableArray *attributeValues;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAttributeValue;


- (IBAction)onAddNewAttrValue:(id)sender;


@end
