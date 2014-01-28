//
//  POSOrderThirdCell_Detail.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/24/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSOrderDetailEditCell.h"
#import "POSBasket.h"
#import "POSSetting.h"
#import "POSObjectsHelper.h"

@interface POSOrderThirdCell_Detail : UITableViewCell<UITableViewDataSource, UITableViewDelegate>

@property NSString *titleValue;
@property NSMutableArray *objectsArray;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableDetail;
@property (weak, nonatomic) IBOutlet UIView *viewFirstGrey;
@property (weak, nonatomic) IBOutlet UIView *viewSecondWhite;


@end
