//
//  POSBasketOpenViewController.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/17/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "POSObjectsHelper.h"
#import "POSDBWrapper.h"
#import "POSOrder.h"
#import "POSBasket.h"
#import "POSOrderEditCell.h"


@interface POSBasketOpenViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableBasket;


- (void)readBasketData:(int)doc_ID;

//- (IBAction)onSave:(id)sender;
//- (IBAction)onCancel:(id)sender;


@end
