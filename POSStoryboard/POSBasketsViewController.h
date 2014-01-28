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
#import "POSSetting.h"
#import "POSOrderThirdCell_Detail.h"


@interface POSBasketsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
    
@private
    NSMutableArray *_objectArray;
    NSString *_filterName;
}


@property (weak, nonatomic) IBOutlet UITableView *tableBasket;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;


- (void)readBasketData:(int)doc_ID;
- (IBAction)onSegmentValueChanged:(id)sender;


@end