//
//  POSBasketEditDynamicCell.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/21/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "POSItem.h"
#import "POSOrder.h"
#import "POSObjectsHelper.h"
#import "POSSetting.h"
#import "POSHelper.h"


@interface POSBasketEditDynamicCell : UITableViewCell


@property POSOrder *order;
@property POSItem *item;

@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelAttribute1;
@property (weak, nonatomic) IBOutlet UILabel *labelAttribute1Value;
@property (weak, nonatomic) IBOutlet UILabel *labelAttribute2;
@property (weak, nonatomic) IBOutlet UILabel *labelAttribute2Value;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceValue;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceCurrency;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelFullPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelFullPriceCurrency;
@property (weak, nonatomic) IBOutlet UILabel *labelRowIndex;

@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;


@end
