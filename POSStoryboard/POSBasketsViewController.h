//
//  POSBasketsViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/27/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSObjectsHelper.h"
#import "POSDBWrapper.h"
#import "POSOrder.h"
#import "POSBasket.h"
#import "POSOrderEditCell.h"


@interface POSBasketsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableBasket;


- (void)readBasketData:(int)doc_ID;


@end