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
#import "POSOrderFirstCell_Mode.h"
#import "POSOrderSecondCell_Header.h"
#import "POSOrderThirdCell_Detail.h"


@interface POSBasketsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
    
@private
    NSMutableArray *_objectArray;
    NSString *_filterName;
    POSSetting *_basketsMode;
}


@property (weak, nonatomic) IBOutlet UITableView *tableBasket;


- (void)readBasketData:(int)doc_ID;
- (IBAction)onSegmentValueChanged:(id)sender;


@end