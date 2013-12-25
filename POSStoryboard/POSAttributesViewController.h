//
//  POSAttributesViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSDataSet.h"
#import "POSObjectsHelper.h"
#import "POSAttributeCell.h"

@interface POSAttributesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
